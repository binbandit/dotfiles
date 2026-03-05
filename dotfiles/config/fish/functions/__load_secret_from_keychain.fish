function __load_secret_from_keychain --argument-names var service
    # Dedup: if we already fetched this service, reuse the value.
    set -l cache_var "__keychain_cache_"(string replace -a '.' '_' -- $service)
    if set -q $cache_var
        set -gx $var $$cache_var
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

    if test -n "$value"
        set -g $cache_var $value
        set -gx $var $value
    end
end
