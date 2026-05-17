function pr --description 'Open PR page on GitHub'
    argparse 'f/fork' -- $argv
    or return 1

    if not git rev-parse --git-dir >/dev/null 2>&1
        echo 'pr: Not in a git repository.' >&2
        return 1
    end

    # Default to upstream when it exists (fork workflow), -f/--fork forces origin
    set -l remote
    if set -q _flag_fork
        set remote origin
    else if git remote get-url upstream >/dev/null 2>&1
        set remote upstream
    else
        set remote origin
    end

    set -l url
    if git remote get-url --push $remote >/dev/null 2>&1
        set url (git remote get-url --push $remote)
    else if git remote get-url $remote >/dev/null 2>&1
        set url (git remote get-url $remote)
    end

    if test -z "$url"
        echo 'pr: Could not determine remote URL.' >&2
        return 1
    end

    # Normalize to HTTPS base URL
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

    # Build PR search URL for current branch
    set -l prurl
    set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if test -n "$branch" -a "$branch" != HEAD
        set prurl "$base/pulls?q=is%3Apr+is%3Aopen+head%3A$branch"
    else
        set prurl "$base/pulls"
    end

    if type -q open
        open $prurl
    else if type -q xdg-open
        xdg-open $prurl
    else
        echo $prurl
    end
end
