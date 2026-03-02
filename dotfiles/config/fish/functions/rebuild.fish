function rebuild --description 'Apply dotfiles with mimic (optional branch)'
    argparse 'b/branch=' 'h/help' -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: rebuild [--branch <name>]"
        echo "       rebuild <name>"
        return 0
    end

    set -l dots "$HOME/.dots"
    set -l nvim_paths \
        "$HOME/.config/nvim" \
        "$HOME/.local/share/nvim" \
        "$HOME/.local/state/nvim" \
        "$HOME/.cache/nvim"
    set -l branch ""

    if set -q _flag_branch
        set branch "$_flag_branch"
        if test (count $argv) -gt 0
            echo "rebuild: choose either --branch or positional branch"
            echo "Usage: rebuild [--branch <name>]"
            return 1
        end
    else if test (count $argv) -gt 0
        set branch "$argv[1]"
    end

    if test (count $argv) -gt 1
        echo "rebuild: too many arguments"
        echo "Usage: rebuild [--branch <name>]"
        return 1
    end

    if not type -q mimic
        echo "mimic not found — install it first: cargo install --git https://github.com/binbandit/mimic.git --locked"
        return 1
    end

    for path in $nvim_paths
        if test -e "$path"
            rm -rf "$path"
        end
    end

    git -C "$dots" pull

    set -l mimic_args apply --yes --config "$dots/mimic.toml"
    if test -n "$branch"
        set mimic_args --branch "$branch" $mimic_args
    end

    and mimic $mimic_args
end
