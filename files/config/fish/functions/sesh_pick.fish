function sesh_pick --description "Connect to a sesh/tmux target via fzf"
    if not type -q sesh
        echo "sesh_pick: sesh command not found" >&2
        return 127
    end

    if not type -q fzf
        echo "sesh_pick: fzf is required" >&2
        return 127
    end

    set -l picker fzf
    set -l picker_args '--reverse' '--height=40%' '--exit-0'
    if set -q TMUX
        if type -q fzf-tmux
            set picker fzf-tmux
            set picker_args '-p' '80%,60%' '--reverse' '--exit-0'
        end
    end

    set -l selection (
        command sesh list --config --tmux --zoxide --hide-duplicates 2>/dev/null \
        | awk 'NF' \
        | awk '!seen[$0]++' \
        | $picker $picker_args
    )

    if test -z "$selection"
        return 1
    end

    if string match -r '^~' -- $selection
        set selection (string replace -r '^~' $HOME -- $selection)
    end

    command sesh connect -- $selection
end
