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
    else if type -q security
        set value (security find-generic-password -w -a $USER -s $service 2>/dev/null)
    end

    # Always cache the result (even if empty) to avoid repeated lookups
    set -U $cache_var "$value"
    
    if test -n "$value"
        set -gx $var $value
    end
end
