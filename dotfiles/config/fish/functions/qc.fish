function qc --description 'Quick git commit with optional push'
    # Check if we're in a git repo
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end

    # Parse arguments
    set -l push_flag false
    set -l commit_message

    for arg in $argv
        switch $arg
            case -p --push
                set push_flag true
            case '*'
                if test -z "$commit_message"
                    set commit_message $arg
                else
                    set commit_message "$commit_message $arg"
                end
        end
    end

    # Require commit message
    if test -z "$commit_message"
        echo "Error: Commit message required"
        return 1
    end

    # Check if there's anything staged
    if not git diff --cached --quiet
        # There are staged changes, use them
        echo "Using existing staged changes..."
    else
        # Nothing staged, add everything
        echo "No staged changes, adding all files..."
        git add .
    end

    # Create commit
    git commit -m "$commit_message"
    or return 1

    # Push if requested
    if test "$push_flag" = true
        echo "Pushing to remote..."
        git push
    end
end
