#!/usr/bin/env bash
set -euo pipefail

OLD_BREWFILE="$HOME/Brewfile"
[ -f "$OLD_BREWFILE" ] && rm -f "$OLD_BREWFILE"

case "$(uname -s)" in
  Darwin)
    if command -v brew >/dev/null 2>&1; then
      if [ -f "$HOME/.config/homebrew/Brewfile" ]; then
        brew bundle --file "$HOME/.config/homebrew/Brewfile"
      fi
    fi
    ;;
  Linux)
    if command -v pacman >/dev/null 2>&1 && [ -f "$HOME/packages-arch.txt" ]; then
      sudo pacman -Syu --noconfirm
      sudo pacman -S --needed --noconfirm $(tr '\n' ' ' < "$HOME/packages-arch.txt")
    fi
    ;;
  *)
    ;;
 esac

if command -v mise >/dev/null 2>&1; then
  mise install
fi
