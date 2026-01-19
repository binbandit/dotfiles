{ lib, defaults, hostConfig, ... }:

let
  fishDefaults = defaults.fish or { };
  fishHost = hostConfig.fish or { };

  paths = (fishDefaults.paths or [ ]) ++ (fishHost.paths or [ ]);
  env = (fishDefaults.env or { }) // (fishHost.env or { });
  proxies = (fishDefaults.proxies or { }) // (fishHost.proxies or { });
  plugins =
    (fishDefaults.plugins.fisherfile or [ ])
    ++ (fishHost.plugins.fisherfile or [ ]);

  roles = hostConfig.roles or [ ];
  isWork = lib.elem "work" roles;

  resolvePath = p:
    if lib.hasPrefix "~/" p then "$HOME/${lib.removePrefix "~/" p}"
    else if lib.hasPrefix "/" p then p
    else "$HOME/${p}";

  resolveValue = v:
    if lib.hasPrefix "~/" v then "$HOME/${lib.removePrefix "~/" v}"
    else v;

  pathBlock = p: ''
    set -l __path "${resolvePath p}"
    if test -d $__path
        fish_add_path $__path
    end
  '';

  envLine = key: value: ''set -gx ${key} "${resolveValue value}"'';

  proxyLines = lib.concatStringsSep "\n" (lib.flatten [
    (lib.optional ((proxies.http or "") != "") ''
      set -gx HTTP_PROXY "${proxies.http}"
      set -gx http_proxy "${proxies.http}"
    '')
    (lib.optional ((proxies.https or "") != "") ''
      set -gx HTTPS_PROXY "${proxies.https}"
      set -gx https_proxy "${proxies.https}"
    '')
    (lib.optional ((proxies.no_proxy or "") != "") ''
      set -gx NO_PROXY "${proxies.no_proxy}"
      set -gx no_proxy "${proxies.no_proxy}"
    '')
  ]);

  configText = ''
    # Homebrew (Apple Silicon default path)
    if test -f /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv | string collect)
    end

    # Runtime manager via mise
    if type -q mise
        mise activate fish | source
    end

    # Runtime manager via direnv (automatic after mise activates hook)
    if type -q direnv
        direnv hook fish | source
    end

    # Path management driven by host data. Directories that do not yet exist are
    # skipped to keep PATH clean on fresh machines.
  ''
  + (lib.concatStringsSep "\n" (map pathBlock paths))
  + ''

    # Export environment variables configured per host.
  ''
  + (lib.concatStringsSep "\n" (lib.mapAttrsToList envLine env))
  + ''

    # Ensure PNPM is configured globally per host.
    if not set -q PNPM_HOME
        set -gx PNPM_HOME "$HOME/Library/pnpm"
    end
    if test -d "$PNPM_HOME"
        fish_add_path $PNPM_HOME
    end

    # HTTP proxy configuration (only emitted when values are populated).
  ''
  + (if proxyLines == "" then "" else proxyLines + "\n")
  + ''
    # Initialize starship prompt when available.
    if type -q starship
        starship init fish | source
    end

    # zoxide improves directory navigation.
    if type -q zoxide
        set -gx _ZO_EXCLUDE_DIRS '**/node_modules/**:**/target/**:**/.git/**:**/tmp/**:**/temp/**:**/.cache/**'
        zoxide init fish --cmd=cd | source
    end

    # Bun runtime tools.
    if set -q BUN_INSTALL
        if test -d "$BUN_INSTALL/bin"
            fish_add_path $BUN_INSTALL/bin
        end
    end

    # Cargo/Rust (ensure the toolchain is prioritized).
    if test -d "$HOME/.cargo/bin"
        fish_add_path $HOME/.cargo/bin
    end

    # Keychain helpers (edit ~/.config/fish/keychain-secrets.fish for mappings)
    function __load_secret_from_keychain --argument-names var service
        set -l value ""
        if type -q keychainctl
            set value (keychainctl get $service 2>/dev/null)
            if test $status -ne 0
                set value ""
            end
        else if type -q security
            set value (security find-generic-password -w -a $USER -s $service 2>/dev/null)
        end

        if test -n "$value"
            set -gx $var $value
        end
    end

    if test -f $HOME/.config/fish/keychain-secrets.fish
        source $HOME/.config/fish/keychain-secrets.fish
    end

    if type -q keychainctl
        function keychain-set --description 'Add or update a keychain secret'
            keychainctl set $argv
        end
        function keychain-get --description 'Print a keychain secret to stdout'
            keychainctl get $argv
        end
        function keychain-rm --description 'Remove a keychain secret'
            keychainctl delete $argv
        end
        function keychain-ls --description 'List keychain secrets for the current user'
            keychainctl list $argv
        end
    end

    # rbenv init
    if type -q rbenv
        rbenv init - fish | source
    end

    # Kiro shell integration
    if test "$TERM_PROGRAM" = "kiro"
        source (kiro --locate-shell-integration-path fish)
    end

    # Google Cloud SDK
    if test -f '/opt/homebrew/share/google-cloud-sdk/path.fish.inc'
        source '/opt/homebrew/share/google-cloud-sdk/path.fish.inc'
    end

    # Daily maintenance helper (brew, mise, rustup).
    function upgrade --description 'Run daily package/runtime upgrades'
        set -l tasks \
            'brew update' \
            'brew upgrade' \
            'brew autoremove' \
            'brew cleanup' \
            'brew cleanup --prune=all' \
            'mise upgrade --bump' \
            'rustup update'

        for task in $tasks
            echo ""
            echo ">>> $task"
            eval $task
            if test $status -ne 0
                echo "upgrade: \"$task\" failed; aborting." >&2
                return $status
            end
        end
    end

    # Bell after every command completion.
    function fish_postexec
        echo -ne '\a'
    end

    if test -d "$HOME/.radicle/bin"
        fish_add_path "$HOME/.radicle/bin"
    end
  '';

  keychainText = ''
    # Keychain-backed environment variables
    # -------------------------------------
    # Add one line per secret you want exported in every shell.
    # Format:
    #   __load_secret_from_keychain <VAR_NAME> <keychain service name>
    #
    # The defaults below cover typical API tokens. Extend as needed.

    __load_secret_from_keychain OPENAI_API_KEY dev.openai.api
    __load_secret_from_keychain LINEAR_API_KEY dev.linear.api
    __load_secret_from_keychain SAGE_GITHUB_TOKEN dev.sage.github
    __load_secret_from_keychain HF_TOKEN dev.huggingface.token
  ''
  + (if isWork then ''
    __load_secret_from_keychain ARTIFACTORY_ENTERPRISE_NPM_AUTH_TOKEN dev.artifactory.enterprise.npm
  '' else "")
  + ''

    # Mirror HF_TOKEN for tooling that expects the alternative variable name.
    if set -q HF_TOKEN
        set -gx HUGGINGFACE_HUB_TOKEN $HF_TOKEN
    end
  '';
in
{
  xdg.configFile."fish/config.fish".text = configText;
  xdg.configFile."fish/fish_plugins".text =
    (lib.concatStringsSep "\n" plugins) + "\n";
  xdg.configFile."fish/keychain-secrets.fish".text = keychainText;
}
