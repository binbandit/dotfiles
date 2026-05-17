function where --description 'Resolve a directory via zoxide'
    if test (count $argv) -eq 0
        echo 'usage: where <query>' >&2
        return 1
    end

    if not command -sq zoxide
        echo 'where: zoxide command not found' >&2
        return 127
    end

    set -l location (command zoxide query -- $argv 2>/dev/null)
    or begin
        echo "where: no match for '$argv'" >&2
        return 1
    end

    printf '%s\n' $location
end
