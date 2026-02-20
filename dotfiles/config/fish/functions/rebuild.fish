function rebuild --description 'Apply dotfiles with mimic'
    set -l dots "$HOME/.dots"

    if not type -q mimic
        echo "mimic not found — install it first: cargo install --git https://github.com/binbandit/mimic.git --locked"
        return 1
    end

    git -C "$dots" pull
    and mimic apply --yes --config "$dots/mimic.toml"
end
