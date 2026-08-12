function cleanrust --description 'Run `cargo clean` in every Rust project under ~/Developer/rust'
    set -l root ~/Developer/rust

    if not test -d $root
        echo "cleanrust: $root does not exist" >&2
        return 1
    end

    for manifest in $root/*/Cargo.toml
        set -l dir (dirname $manifest)
        echo "Cleaning "(basename $dir)
        cargo clean --manifest-path $manifest
    end
end
