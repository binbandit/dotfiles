# Fast mise activation with PATH caching
# This applies mise paths immediately from cache, then verifies in background

# Check if we have a cached mise PATH
if set -q _mise_cached_paths
    # Prepend cached mise paths immediately
    for path_entry in $_mise_cached_paths
        if test -d $path_entry
            fish_add_path --prepend --global $path_entry
        end
    end
    
    # Disable vendor mise auto-activation since we're handling it
    set -gx MISE_FISH_AUTO_ACTIVATE 0
    
    # Verify and update cache in background on directory change
    function __mise_lazy_verify --on-variable PWD
        if type -q mise
            # Run mise hook-env to get fresh environment
            mise hook-env -s fish | source
            # Update cached paths for next shell
            set -U _mise_cached_paths (string match -r '/.*mise/installs/[^:]+' $PATH)
        end
        # Remove this function after first verification
        functions -e __mise_lazy_verify
    end
else
    # First run - do full activation and cache the paths
    if test "$MISE_FISH_AUTO_ACTIVATE" != "0"
        mise activate fish | source
        # Cache mise paths for future shells
        set -U _mise_cached_paths (string match -r '/.*mise/installs/[^:]+' $PATH)
        set -gx MISE_FISH_AUTO_ACTIVATE 0
    end
end
