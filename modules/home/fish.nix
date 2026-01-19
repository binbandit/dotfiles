{ lib, defaults, hostConfig, hostName, ... }:

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
# Managed by home-manager.
# Keep this file minimal; see conf.d for the real config.
  '';

  hostText = ''
# Host profile: ${hostName}
# Generated from lib/hosts.nix

# Paths
  ''
  + (lib.concatStringsSep "\n" (map pathBlock paths))
  + ''

# Env
  ''
  + (lib.concatStringsSep "\n" (lib.mapAttrsToList envLine env))
  + ''

# PNPM
if not set -q PNPM_HOME
    set -gx PNPM_HOME "$HOME/Library/pnpm"
end
if test -d "$PNPM_HOME"
    fish_add_path $PNPM_HOME
end
  ''
  + (if proxyLines == "" then "" else "\n# Proxies\n" + proxyLines + "\n");

  initText = ''
# Shell init: tools + helpers

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

if status is-interactive
    # Prompt
    if type -q starship
        starship init fish | source
    end

    # zoxide improves directory navigation.
    if type -q zoxide
        set -gx _ZO_EXCLUDE_DIRS '**/node_modules/**:**/target/**:**/.git/**:**/tmp/**:**/temp/**:**/.cache/**'
        zoxide init fish --cmd=cd | source
    end
end

# Keychain-backed env vars
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

# Bell after every command completion.
function fish_postexec
    echo -ne '\a'
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
  xdg.configFile."fish/conf.d/00-init.fish".text = initText;
  xdg.configFile."fish/conf.d/10-host.fish".text = hostText;
  xdg.configFile."fish/fish_plugins".text =
    (lib.concatStringsSep "\n" plugins) + "\n";
  xdg.configFile."fish/keychain-secrets.fish".text = keychainText;
}
