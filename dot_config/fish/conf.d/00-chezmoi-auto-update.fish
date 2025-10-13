if status is-interactive
    if not set -q __CHEZMOI_AUTO_SYNC_STARTED
        set -gx __CHEZMOI_AUTO_SYNC_STARTED 1

        if type -q chezmoi-sync
            # Run the pull/apply step asynchronously so shell startup stays fast.
            command nohup chezmoi-sync pull >/dev/null 2>&1 &
        else if type -q chezmoi
            # Fallback: best-effort pull/apply using chezmoi directly.
            command nohup chezmoi git pull --rebase --autostash --quiet >/dev/null 2>&1 &
            command nohup chezmoi apply --force --keep-going >/dev/null 2>&1 &
        end
    end
end
