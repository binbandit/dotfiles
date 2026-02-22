function wrm --description 'Remove a git workty worktree'
    set -l flags
    set -l targets
    set -l parsing_flags 1

    for arg in $argv
        if test $parsing_flags -eq 1
            if test "$arg" = "--"
                set parsing_flags 0
            else if string match -qr '^-' -- "$arg"
                set -a flags "$arg"
            else
                set -a targets "$arg"
            end
        else
            set -a targets "$arg"
        end
    end

    if test (count $targets) -eq 0
        git workty rm $argv
        return $status
    end

    set -l rc 0
    for target in $targets
        git workty rm $flags -- $target
        if test $status -ne 0
            set rc $status
        end
    end

    return $rc
end
