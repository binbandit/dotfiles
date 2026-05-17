function src --description 'Reload fish config'
    set -l cfg "$__fish_config_dir/config.fish"

    if test -f "$cfg"
        source "$cfg"
    else
        echo "src: missing $cfg"
        echo "Run: mimic apply --config ~/.dots/mimic.toml"
        return 1
    end
end
