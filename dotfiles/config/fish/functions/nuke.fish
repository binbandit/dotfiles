function nuke --description 'Delete all uncommitted files and folders in git repo'
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end

    # Show what will be deleted
    echo "The following files and directories will be deleted:"
    echo ""
    git clean -fdxn
    echo ""
    
    # Ask for confirmation
    read -l -P "Are you sure you want to delete all uncommitted files? (yes/no): " confirm
    
    if test "$confirm" = "yes"
        # Remove all untracked files and directories
        # -f: force
        # -d: remove directories
        # -x: remove ignored files too
        git clean -fdx
        
        # Reset all tracked files to their committed state
        git reset --hard HEAD
        
        echo ""
        echo "✓ Repository nuked: all uncommitted changes removed"
    else
        echo "Aborted: no files were deleted"
        return 1
    end
end
