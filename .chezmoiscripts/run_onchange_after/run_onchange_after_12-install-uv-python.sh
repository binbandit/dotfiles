#!/usr/bin/env bash
set -euo pipefail

PY_VERSION="3.12"

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

uv python install "$PY_VERSION"

PY_BIN="$(uv python path --python "$PY_VERSION")"
if [ -z "$PY_BIN" ] || [ ! -x "$PY_BIN" ]; then
  echo "Failed to locate uv-managed python for version $PY_VERSION" >&2
  exit 1
fi

PY_DIR="$(dirname "$PY_BIN")"
PIP_BIN="$PY_DIR/pip3"

ln -sf "$PY_BIN" "$HOME/.local/bin/python"
ln -sf "$PY_BIN" "$HOME/.local/bin/python3"
if [ -x "$PIP_BIN" ]; then
  ln -sf "$PIP_BIN" "$HOME/.local/bin/pip"
  ln -sf "$PIP_BIN" "$HOME/.local/bin/pip3"
fi
