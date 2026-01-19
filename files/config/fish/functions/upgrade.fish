function upgrade --description 'Run daily package/runtime upgrades'
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
        if test $status -ne 0
            echo "upgrade: \"$task\" failed; aborting." >&2
            return $status
        end
    end
end
