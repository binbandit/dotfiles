function nuke --description 'Delete all uncommitted files and folders in git repo'
    # Parse arguments
    set -l skip_confirm 0
    for arg in $argv
        switch $arg
            case -y --yes
                set skip_confirm 1
        end
    end

    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end

    # Show what will be deleted
    if test $skip_confirm -eq 0
        echo "The following files and directories will be deleted:"
        echo ""
        git clean -fdn
        echo ""
    end
    
    # Ask for confirmation unless -y/--yes flag provided
    set -l confirm "yes"
    if test $skip_confirm -eq 0
        read -l -P "Are you sure you want to delete all uncommitted files? (y/n): " confirm
    end
    
    if test "$confirm" = "y" -o "$confirm" = "yes"
        # Remove all untracked files and directories (respects .gitignore)
        git clean -fd
        
        # Reset all tracked files to their committed state
        git reset --hard HEAD
        
        echo ""
        echo "✓ Repository nuked: all uncommitted changes removed"
    else
        echo "Aborted: no files were deleted"
        return 1
    end
end
