#!/usr/bin/env bash
set -euo pipefail

DOTS_DIR="${DOTS_DIR:-$HOME/.dots}"
REPO_URL="https://github.com/binbandit/dotfiles.git"

log() {
  printf '[bootstrap] %s\n' "$*"
}

ensure_lix() {
  if command -v nix >/dev/null 2>&1; then
    return 0
  fi

  log "Installing Lix..."
  curl -sSf -L https://install.lix.systems/lix | sh -s -- install
}

clone_repo() {
  if [ -d "$DOTS_DIR/.git" ]; then
    log "Updating existing repo at $DOTS_DIR"
    git -C "$DOTS_DIR" pull --ff-only
    return 0
  fi

  log "Cloning dotfiles to $DOTS_DIR"
  git clone "$REPO_URL" "$DOTS_DIR"
}

main() {
  ensure_lix
  clone_repo

  log "Next: run 'rebuild' (or nix-darwin switch) from a new shell."
}

main "$@"
