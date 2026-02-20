function pr --description 'Open PR page on GitHub without gh'
    # Ensure we're in a git repo
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo 'pr: Not in a git repository.' >&2
        return 1
    end

    # Determine remote URL (prefer push URL for origin)
    set -l url
    if git remote get-url --push origin >/dev/null 2>&1
        set url (git remote get-url --push origin)
    else if git remote get-url origin >/dev/null 2>&1
        set url (git remote get-url origin)
    else
        set url (git remote -v | head -n1 | awk '{print $2}')
    end

    if test -z "$url"
        echo 'pr: Could not determine remote URL.' >&2
        return 1
    end

    # Normalize to HTTPS base URL suitable for browser
    set -l base
    if string match -q 'git@*' -- $url
        set -l hostpath (string replace -r '^git@' '' -- $url)
        set -l host (string split -m1 ':' $hostpath)[1]
        set -l path (string split -m1 ':' $hostpath)[2]
        set base "https://$host/$path"
    else if string match -q 'ssh://git@*' -- $url
        set -l parts (string replace -r '^ssh://git@' '' -- $url)
        set -l host (string split -m1 '/' $parts)[1]
        set -l path (string split -m1 '/' $parts)[2]
        set base "https://$host/$path"
    else if string match -q 'git://*' -- $url
        set base (string replace -r '^git://' 'https://' -- $url)
    else
        set base $url
    end
    set base (string replace -r '\\.git$' '' -- $base)

    # Decide target URL
    set -l prurl
    if test (count $argv) -gt 0
        set -l target $argv[1]
        # If arg is a PR number (optionally prefixed with #)
        set -l num (string replace -r '^#' '' -- $target)
        if string match -qr '^[0-9]+$' -- $num
            set prurl "$base/pull/$num"
        else if test "$target" = 'list' -o "$target" = 'pulls'
            set prurl "$base/pulls"
        else if test "$target" = 'new' -o "$target" = 'create'
            # Open compare page for current branch (best-effort; assumes main or master)
            set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
            if test -z "$branch" -o "$branch" = 'HEAD'
                set prurl "$base/pulls"
            else
                # Try to read local origin/HEAD to guess default branch; fallback to main then master
                set -l default_branch
                if test -e (git rev-parse --git-dir)/refs/remotes/origin/HEAD
                    set -l ref (cat (git rev-parse --git-dir)/refs/remotes/origin/HEAD)
                    set default_branch (string replace -r '^ref:\\s+refs/remotes/origin/' '' -- $ref)
                end
                if test -z "$default_branch"
                    if git show-ref --verify --quiet refs/heads/main
                        set default_branch main
                    else if git show-ref --verify --quiet refs/heads/master
                        set default_branch master
                    else
                        set default_branch main
                    end
                end
                set prurl "$base/compare/$default_branch...$branch?expand=1"
            end
        else
            # Treat as branch name: open search for open PRs with that head
            set prurl "$base/pulls?q=is%3Apr+is%3Aopen+head%3A$target"
        end
    else
        # No args: search for open PRs for current branch
        set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if test -z "$branch" -o "$branch" = 'HEAD'
            set prurl "$base/pulls"
        else
            set prurl "$base/pulls?q=is%3Apr+is%3Aopen+head%3A$branch"
        end
    end

    # Open in default browser, or print URL
    if type -q open
        open $prurl
    else if type -q xdg-open
        xdg-open $prurl
    else
        echo $prurl
    end
end
