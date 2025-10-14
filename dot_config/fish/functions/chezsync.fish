function chezsync --description 'Sync chezmoi changes to and from remote'
    set -l pull_status 0
    set -l push_status 0

    if type -q chezmoi-sync
        chezmoi-sync pull
        set pull_status $status
        if test $pull_status -eq 0
            chezmoi-sync push
            set push_status $status
        end
    else if type -q chezmoi
        chezmoi update --keep-going --no-pager
        set pull_status $status
        if test $pull_status -eq 0
            set needs_commit 0
            if chezmoi git status --porcelain | string trim | string length -q
                set needs_commit 1
            end

            if test $needs_commit -eq 1
                chezmoi git add -A
                set commit_msg (printf 'chore(sync): %s %s' (hostname -s) (date '+%Y-%m-%d %H:%M:%S'))
                chezmoi git commit -m "$commit_msg" >/dev/null 2>&1
            end

            chezmoi git push
            set push_status $status
        end
    else
        echo "chezsync: neither chezmoi-sync nor chezmoi is available." >&2
        return 127
    end

    if test $pull_status -ne 0
        echo "chezsync: pull/apply step failed." >&2
        return $pull_status
    end

    if test $push_status -ne 0
        echo "chezsync: push step failed." >&2
        return $push_status
    end
end
