#!/usr/bin/env bash
set -euo pipefail

DOTS_DIR="${DOTS_DIR:-$HOME/.dots}"
REPO_URL="https://github.com/binbandit/dotfiles.git"

log() {
  printf '[bootstrap] %s\n' "$*"
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to current PATH (Apple Silicon default)
  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

ensure_mimic() {
  if command -v mimic >/dev/null 2>&1; then
    return 0
  fi

  log "Installing mimic..."
  if ! command -v cargo >/dev/null 2>&1; then
    log "Installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
    export PATH="$HOME/.cargo/bin:$PATH"
  fi

  cargo install --git https://github.com/binbandit/mimic.git --locked
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
  ensure_homebrew
  ensure_mimic
  clone_repo

  log "Applying dotfiles with mimic (includes hooks for runtimes + tools)..."
  mimic apply --yes --config "$DOTS_DIR/mimic.toml"

  log "Done! Open a new shell to pick up your configuration."
}

main "$@"
