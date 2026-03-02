# Fast mise activation with stable shim-first PATH handling
# Keep a small cache, but never rely on versioned install paths.

set -l __mise_data_dir "$HOME/.local/share/mise"
if set -q MISE_DATA_DIR
    set __mise_data_dir "$MISE_DATA_DIR"
end
set -g __mise_shims_path "$__mise_data_dir/shims"

# Always prepend shims first so tool switches never break command resolution.
if test -d "$__mise_shims_path"
    fish_add_path --prepend --global "$__mise_shims_path"
end

# Keep old cache support, but only use existing non-shim paths.
if set -q _mise_cached_paths
    for path_entry in $_mise_cached_paths
        if test "$path_entry" != "$__mise_shims_path"; and test -d "$path_entry"
            fish_add_path --prepend --global "$path_entry"
        end
    end
end

# Disable vendor mise auto-activation since we're handling it.
set -gx MISE_FISH_AUTO_ACTIVATE 0

if type -q mise
    # Verify and update env once after first directory change.
    function __mise_lazy_verify --on-variable PWD
        mise hook-env -s fish | source
        set -U _mise_cached_paths "$__mise_shims_path"
        functions -e __mise_lazy_verify
    end

    # First run: do full activation once, then cache only shims.
    if not set -q _mise_cached_paths
        mise activate fish | source
    end
    set -U _mise_cached_paths "$__mise_shims_path"
end
