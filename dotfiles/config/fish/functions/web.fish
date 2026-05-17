function web --description 'Open repository page from git remote'
    # Ensure we're in a git repo
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo 'web: Not in a git repository.' >&2
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
        echo 'web: Could not determine remote URL.' >&2
        return 1
    end

    # Normalize to HTTPS URL suitable for a browser
    set -l weburl
    if string match -q 'git@*' -- $url
        # git@host:org/repo(.git)
        set -l hostpath (string replace -r '^git@' '' -- $url)
        set -l host (string split -m1 ':' $hostpath)[1]
        set -l path (string split -m1 ':' $hostpath)[2]
        set weburl "https://$host/$path"
    else if string match -q 'ssh://git@*' -- $url
        # ssh://git@host/org/repo(.git)
        set -l parts (string replace -r '^ssh://git@' '' -- $url)
        set -l host (string split -m1 '/' $parts)[1]
        set -l path (string split -m1 '/' $parts)[2]
        set weburl "https://$host/$path"
    else if string match -q 'git://*' -- $url
        set weburl (string replace -r '^git://' 'https://' -- $url)
    else
        # Assume already http(s) URL
        set weburl $url
    end

    # Strip trailing .git if present
    set weburl (string replace -r '\.git$' '' -- $weburl)

    # Append subpath if provided (e.g., issues, pulls)
    if test (count $argv) -gt 0
        set -l suffix (string join '/' $argv)
        set weburl "$weburl/$suffix"
    end

    # Open in default browser, or print URL if no opener
    if type -q open
        open $weburl
    else if type -q xdg-open
        xdg-open $weburl
    else
        echo $weburl
    end
end
