#!/usr/bin/env bash
# Bootstrap a new machine with BinBandit's chezmoi-managed dotfiles.
# Usage:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/binbandit/dotfiles/main/scripts/bootstrap.sh)"

set -euo pipefail

REPO_OWNER="binbandit"
REPO_NAME="dotfiles"
GITHUB_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}.git"

log() {
  printf '[bootstrap] %s\n' "$*"
}

fatal() {
  printf '[bootstrap] ERROR: %s\n' "$*" >&2
  exit 1
}

ensure_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    return 1
  fi
}

install_homebrew() {
  if ensure_command brew; then
    return
  fi

  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Ensure brew is on PATH for the current shell session.
  if [ -d "/opt/homebrew/bin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -d "/usr/local/bin" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_macos_requirements() {
  log "Detected macOS."

  if ! xcode-select -p >/dev/null 2>&1; then
    log "Installing Xcode command-line tools..."
    xcode-select --install >/dev/null 2>&1 || true
    # Wait until installation completes.
    until xcode-select -p >/dev/null 2>&1; do
      sleep 20
    done
  fi

  install_homebrew

  log "Installing chezmoi and git via Homebrew..."
  brew install chezmoi git >/dev/null 2>&1 || brew upgrade chezmoi git >/dev/null 2>&1 || true
}

install_arch_requirements() {
  log "Detected Arch Linux."
  sudo pacman -Sy --needed --noconfirm git chezmoi
}

install_debian_requirements() {
  log "Detected Debian/Ubuntu."
  sudo apt-get update
  sudo apt-get install -y git curl
  if ! ensure_command chezmoi; then
    log "Installing chezmoi via official install script..."
    sh -c "$(curl -fsSL https://chezmoi.io/get)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi
}

bootstrap_os_dependencies() {
  case "$(uname -s)" in
    Darwin)
      install_macos_requirements
      ;;
    Linux)
      if [ -f /etc/arch-release ]; then
        install_arch_requirements
      elif [ -f /etc/debian_version ] || ensure_command apt-get; then
        install_debian_requirements
      else
        fatal "Unsupported Linux distribution. Install git and chezmoi manually, then rerun this script."
      fi
      ;;
    *)
      fatal "Unsupported operating system: $(uname -s)"
      ;;
  esac
}

init_chezmoi() {
  if [ -d "$HOME/.local/share/chezmoi" ]; then
    log "chezmoi source directory already exists. Skipping init."
    return
  fi

  log "Initializing chezmoi and applying dotfiles..."
  chezmoi init --apply "${REPO_OWNER}"
}

post_apply() {
  if [ -x "$HOME/.local/bin/chezmoi-sync" ]; then
    log "Performing initial chezmoi-sync pull..."
    "$HOME/.local/bin/chezmoi-sync" pull || true
  fi

  log "Bootstrap complete. Review README for LaunchAgent/systemd setup instructions."
}

main() {
  bootstrap_os_dependencies
  init_chezmoi
  post_apply
}

main "$@"
