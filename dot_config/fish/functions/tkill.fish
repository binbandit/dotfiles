function tkill --description 'Kill tmux server'
    if not type -q tmux
        printf 'tmux not found\n' >&2
        return 127
    end

    tmux kill-server
end
