function doc --description 'Open GitHub Pages site for the repository'
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo 'doc: Not in a git repository.' >&2
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
        echo 'doc: Could not determine remote URL.' >&2
        return 1
    end

    # Extract host and owner/repo path from the remote URL
    set -l host
    set -l path
    if string match -q 'git@*' -- $url
        set -l hostpath (string replace -r '^git@' '' -- $url)
        set host (string split -m1 ':' $hostpath)[1]
        set path (string split -m1 ':' $hostpath)[2]
    else if string match -q 'ssh://git@*' -- $url
        set -l parts (string replace -r '^ssh://git@' '' -- $url)
        set host (string split -m1 '/' $parts)[1]
        set path (string split -m1 '/' $parts)[2]
    else if string match -q 'http*://*' -- $url
        set -l stripped (string replace -r '^https?://' '' -- $url)
        set host (string split -m1 '/' $stripped)[1]
        set path (string split -m1 '/' $stripped)[2]
    else if string match -q 'git://*' -- $url
        set -l stripped (string replace -r '^git://' '' -- $url)
        set host (string split -m1 '/' $stripped)[1]
        set path (string split -m1 '/' $stripped)[2]
    end

    set path (string replace -r '\.git$' '' -- $path)

    if test -z "$path"
        echo 'doc: Could not parse owner/repo from remote URL.' >&2
        return 1
    end

    set -l owner (string split -m1 '/' $path)[1]
    set -l repo (string split -m1 '/' $path)[2]

    if test -z "$owner" -o -z "$repo"
        echo 'doc: Could not parse owner/repo from remote URL.' >&2
        return 1
    end

    # Prefer the actual configured Pages URL when gh is available (handles
    # custom domains and user/org sites correctly). Fall back to the
    # conventional <owner>.github.io/<repo>/ URL.
    set -l docurl
    if type -q gh
        set -l api_url (gh api "repos/$owner/$repo/pages" --jq .html_url 2>/dev/null)
        if test -n "$api_url"
            set docurl $api_url
        end
    end

    if test -z "$docurl"
        set -l lowner (string lower $owner)
        set -l lrepo (string lower $repo)
        if test "$lrepo" = "$lowner.github.io"
            set docurl "https://$lrepo/"
        else
            set docurl "https://$lowner.github.io/$repo/"
        end
    end

    # Append subpath if provided
    if test (count $argv) -gt 0
        set -l suffix (string join '/' $argv)
        set docurl (string replace -r '/?$' '/' -- $docurl)"$suffix"
    end

    if type -q open
        open $docurl
    else if type -q xdg-open
        xdg-open $docurl
    else
        echo $docurl
    end
end
