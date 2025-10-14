if status is-interactive
    if not set -q __CHEZMOI_AUTO_SYNC_STARTED
        set -gx __CHEZMOI_AUTO_SYNC_STARTED 1

        if type -q chezmoi-sync
            # Run the pull/apply step asynchronously so shell startup stays fast.
            command nohup chezmoi-sync pull >/dev/null 2>&1 &
        else if type -q chezmoi
            # Fallback: use chezmoi's built-in update command to pull and apply.
            command nohup chezmoi update --keep-going --no-pager >/dev/null 2>&1 &
        end
    end
end
