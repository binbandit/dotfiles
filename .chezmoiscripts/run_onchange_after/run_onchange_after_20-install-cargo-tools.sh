#!/usr/bin/env bash
set -euo pipefail

if ! command -v cargo >/dev/null 2>&1; then
  exit 0
fi

tools=(
  "name=sg git=https://github.com/sage-scm/sage.git bin=sg"
  "name=keychainctl git=https://github.com/binbandit/keychainctl.git"
)

for entry in "${tools[@]}"; do
  unset name git bin
  eval "$entry"
  if [[ -z "${name:-}" || -z "${git:-}" ]]; then
    continue
  fi

  args=(install "$name" --git "$git" --locked)
  if [[ -n "${bin:-}" ]]; then
    args+=(--bin "$bin")
  fi

  if cargo install --list 2>/dev/null | grep -q "^${name} "; then
    if ! cargo "${args[@]}" --force >/dev/null 2>&1; then
      echo "Warning: failed to update cargo tool ${name} from ${git}" >&2
    fi
  else
    if ! cargo "${args[@]}" >/dev/null 2>&1; then
      echo "Warning: failed to install cargo tool ${name} from ${git}" >&2
    fi
  fi

done
