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
