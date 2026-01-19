function rebuild --description 'Rebuild nix-darwin system'
    set -l host (scutil --get LocalHostName 2>/dev/null)
    if test -z "$host"
        set host (hostname -s)
    end
    set -l dots "$HOME/.dots"

    if type -q darwin-rebuild
        darwin-rebuild switch --flake "$dots#$host"
        return $status
    end

    nix run github:LnL7/nix-darwin -- switch --flake "$dots#$host"
end
