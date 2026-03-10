function __load_secret_from_keychain --argument-names var service
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
        set -gx $var $value
    end
end
