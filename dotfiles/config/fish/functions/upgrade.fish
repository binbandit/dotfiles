function upgrade --description 'Run daily package/runtime upgrades'
    set -l failed 0

    set -l tasks \
        'brew update' \
        'brew upgrade' \
        'brew autoremove' \
        'brew cleanup' \
        'brew cleanup --prune=all' \
        'mise upgrade --bump' \
        'rustup update'

    for task in $tasks
        echo ""
        echo ">>> $task"
        eval $task
        or begin
            echo "upgrade: \"$task\" failed; continuing." >&2
            set failed 1
        end
    end

    return $failed
end
