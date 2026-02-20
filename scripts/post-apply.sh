#!/usr/bin/env bash
# post-apply.sh — runs after `mimic apply` to set up runtimes and tools.
# This replaces the nix home-manager activation scripts.
set -euo pipefail

log() {
  printf '[post-apply] %s\n' "$*"
}

UV_PYTHON_VERSION="${UV_PYTHON_VERSION:-3.12}"

# ── mise: install declared runtimes ──────────────────────────

setup_mise() {
  if ! command -v mise >/dev/null 2>&1; then
    return 0
  fi

  log "Installing mise runtimes..."
  mise install >/dev/null 2>&1 || true
}

# ── uv: install Python + symlinks ────────────────────────────

setup_uv_python() {
  if ! command -v uv >/dev/null 2>&1; then
    return 0
  fi

  log "Setting up Python ${UV_PYTHON_VERSION} via uv..."
  mkdir -p "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"

  uv python install "${UV_PYTHON_VERSION}" >/dev/null 2>&1 || true

  PY_BIN="$(uv python find "${UV_PYTHON_VERSION}" 2>/dev/null || true)"
  if [ -n "${PY_BIN}" ] && [ -x "${PY_BIN}" ]; then
    ln -sf "$PY_BIN" "$HOME/.local/bin/python"
    ln -sf "$PY_BIN" "$HOME/.local/bin/python3"

    PIP_BIN="$(dirname "$PY_BIN")/pip3"
    if [ -x "$PIP_BIN" ]; then
      ln -sf "$PIP_BIN" "$HOME/.local/bin/pip"
      ln -sf "$PIP_BIN" "$HOME/.local/bin/pip3"
    fi
  fi
}

# ── rustup: toolchains + components ──────────────────────────

setup_rustup() {
  if ! command -v rustup >/dev/null 2>&1; then
    if command -v rustup-init >/dev/null 2>&1; then
      log "Initializing rustup..."
      rustup-init -y --default-toolchain stable >/dev/null 2>&1 || true
    else
      return 0
    fi
  fi

  export PATH="$HOME/.cargo/bin:$PATH"

  log "Installing Rust toolchains..."
  for tc in stable nightly; do
    rustup toolchain install "$tc" >/dev/null 2>&1 || true
  done

  for component in rustfmt clippy rust-analyzer rust-src rust-docs; do
    for tc in stable nightly; do
      rustup component add --toolchain "$tc" "$component" >/dev/null 2>&1 || true
    done
  done

  rustup component add --toolchain nightly rustc-codegen-cranelift >/dev/null 2>&1 || true

  for target in x86_64-unknown-linux-musl; do
    for tc in stable nightly; do
      rustup target add --toolchain "$tc" "$target" >/dev/null 2>&1 || true
    done
  done

  rustup default nightly >/dev/null 2>&1 || true
}

# ── cargo: install tools from git ────────────────────────────

setup_cargo_tools() {
  if ! command -v cargo >/dev/null 2>&1; then
    return 0
  fi

  log "Installing cargo tools..."

  # tap - terminal task runner
  if ! cargo install --list 2>/dev/null | grep -q "^tap "; then
    cargo install tap --git https://github.com/crazywolf132/tap.git --locked >/dev/null 2>&1 || true
  fi

  # sg (sage) - smart git CLI
  if ! cargo install --list 2>/dev/null | grep -q "^sg "; then
    cargo install sg --git https://github.com/sage-scm/sage.git --locked --bin sg >/dev/null 2>&1 || true
  fi

  # keychainctl - macOS keychain manager
  if ! cargo install --list 2>/dev/null | grep -q "^keychainctl "; then
    cargo install keychainctl --git https://github.com/binbandit/keychainctl.git --locked >/dev/null 2>&1 || true
  fi
}

# ── fish: set as default shell ───────────────────────────────

setup_fish_shell() {
  FISH_PATH="$(command -v fish 2>/dev/null || true)"
  if [ -z "$FISH_PATH" ]; then
    return 0
  fi

  # Add fish to allowed shells if not already there
  if ! grep -qF "$FISH_PATH" /etc/shells 2>/dev/null; then
    log "Adding fish to /etc/shells (may need sudo)..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null 2>&1 || true
  fi

  # Set fish as default shell if not already
  if [ "$SHELL" != "$FISH_PATH" ]; then
    log "Setting fish as default shell..."
    chsh -s "$FISH_PATH" >/dev/null 2>&1 || true
  fi
}

# ── Fisher: install fish plugins ─────────────────────────────

setup_fisher() {
  FISH_PATH="$(command -v fish 2>/dev/null || true)"
  if [ -z "$FISH_PATH" ]; then
    return 0
  fi

  # Install Fisher if not present
  if ! "$FISH_PATH" -c "type -q fisher" 2>/dev/null; then
    log "Installing Fisher plugin manager..."
    "$FISH_PATH" -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher' >/dev/null 2>&1 || true
  fi

  # Install plugins from fish_plugins file
  if [ -f "$HOME/.config/fish/fish_plugins" ]; then
    log "Installing fish plugins via Fisher..."
    "$FISH_PATH" -c 'fisher update' >/dev/null 2>&1 || true
  fi
}

# ── main ─────────────────────────────────────────────────────

main() {
  setup_mise
  setup_uv_python
  setup_rustup
  setup_cargo_tools
  setup_fish_shell
  setup_fisher
  log "Post-apply setup complete."
}

main "$@"
