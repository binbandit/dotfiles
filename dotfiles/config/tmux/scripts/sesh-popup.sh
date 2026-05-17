#!/usr/bin/env bash
set -euo pipefail

# Build the candidate list once and drop empty lines/duplicates.
mapfile -t lines < <(sesh list --config --tmux --zoxide --hide-duplicates 2>/dev/null | awk 'NF' | awk '!seen[$0]++')
if [[ ${#lines[@]} -eq 0 ]]; then
  exit 0
fi

selection=$(printf '%s\n' "${lines[@]}" | fzf-tmux -p 80%,70% --reverse --exit-0 --select-1)

if [[ -z "${selection:-}" ]]; then
  exit 0
fi

# Expand leading ~ so tmux passes an absolute path to sesh.
if [[ "${selection}" == ~* ]]; then
  selection="${selection/#~/$HOME}"
fi

exec sesh connect -- "${selection}"
