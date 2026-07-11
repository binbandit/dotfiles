function src --description 'Reload fish config'
    set -l cfg "$__fish_config_dir/config.fish"
    set -l confd "$__fish_config_dir/conf.d"

    if not test -f "$cfg"
        echo "src: missing $cfg"
        echo "Run: mimic apply --config ~/.dots/mimic.toml"
        return 1
    end

    if test -d "$confd"
        for snippet in "$confd"/*.fish
            source "$snippet"
        end
    end

    source "$cfg"
end
