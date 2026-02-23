# Shell init: tools + helpers

# Homebrew (Apple Silicon default path) without spawning `brew shellenv`.
if test -d /opt/homebrew
    set -gx HOMEBREW_PREFIX /opt/homebrew
    set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
    set -gx HOMEBREW_REPOSITORY /opt/homebrew
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
end

# Ensure Cargo-installed tools are available very early in startup.
if test -d "$HOME/.cargo/bin"
    fish_add_path "$HOME/.cargo/bin"
end

# Runtime manager (mise) is auto-activated via Homebrew vendor_conf.d
# No manual activation needed here to avoid double-activation overhead

if status is-interactive
    # Set theme once (or when changed) without reapplying every shell.
    if not set -q fish_theme; or test "$fish_theme" != "ayu-mirage"
        fish_config theme choose ayu-mirage >/dev/null 2>&1
    end

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

# Keychain secret loader with caching (including negative results)
function __load_secret_from_keychain --argument-names var service
    # Check if already cached in universal variable (including empty/not-found results)
    set -l cache_var "_keychain_cache_$var"
    if set -q $cache_var
        # Only export if non-empty
        if test -n "$$cache_var"
            set -gx $var $$cache_var
        end
        return
    end

    set -l value ""
    if type -q keychainctl
        set value (keychainctl get $service 2>/dev/null)
        if test $status -ne 0
            set value ""
        end
    end

    if test -z "$value"
        if type -q security
            set value (security find-generic-password -w -a "$USER" -s "$service" 2>/dev/null)
            if test $status -ne 0; or test -z "$value"
                set value (security find-generic-password -w -s "$service" 2>/dev/null)
            end
        end
    end

    # Always cache the result (even if empty) to avoid repeated lookups
    set -U $cache_var "$value"
    
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
