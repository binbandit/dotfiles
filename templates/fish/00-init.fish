# Shell init: tools + helpers

# Homebrew (Apple Silicon default path) without spawning `brew shellenv`.
if test -d /opt/homebrew
    set -gx HOMEBREW_PREFIX /opt/homebrew
    set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
    set -gx HOMEBREW_REPOSITORY /opt/homebrew
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
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

# Keychain secret loader — defined inline so it's available before
# keychain-secrets.fish is sourced (cannot rely on functions/ autoload
# since the directory may be a symlink that fish hasn't indexed yet).
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

# Keychain-backed env vars (needed for both interactive and non-interactive shells).
if test -f $HOME/.config/fish/keychain-secrets.fish
    source $HOME/.config/fish/keychain-secrets.fish
end

if status is-interactive
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
end

# Kiro shell integration
if test "$TERM_PROGRAM" = "kiro"
    source (kiro --locate-shell-integration-path fish)
end

# Google Cloud SDK
if test -f '/opt/homebrew/share/google-cloud-sdk/path.fish.inc'
    source '/opt/homebrew/share/google-cloud-sdk/path.fish.inc'
end

# Disable XON/XOFF flow control (prevents Ctrl+S from freezing terminal).
stty -ixon 2>/dev/null

# Bell after every command completion.
function fish_postexec
    echo -ne '\a'
end
