#!/usr/bin/env bash
set -euo pipefail

if ! command -v rustup >/dev/null 2>&1; then
  if ! command -v rustup-init >/dev/null 2>&1 && command -v brew >/dev/null 2>&1; then
    brew install rustup-init >/dev/null
  fi

  if command -v rustup-init >/dev/null 2>&1; then
    rustup-init -y --default-toolchain stable >/dev/null
  else
    echo "rustup not found and rustup-init missing; skipping rust toolchain bootstrap." >&2
    exit 0
  fi
fi

export PATH="$HOME/.cargo/bin:$PATH"

toolchains=(stable nightly)
for tc in "${toolchains[@]}"; do
  rustup toolchain install "$tc" >/dev/null
done

common_components=(
  rustfmt
  clippy
  rust-analyzer
  rust-src
  rust-docs
)

for component in "${common_components[@]}"; do
  for tc in "${toolchains[@]}"; do
    rustup component add --toolchain "$tc" "$component" >/dev/null || true
  done
done

rustup component add --toolchain nightly rustc-codegen-cranelift >/dev/null || true

for target in x86_64-unknown-linux-musl; do
  for tc in "${toolchains[@]}"; do
    rustup target add --toolchain "$tc" "$target" >/dev/null || true
  done
done

rustup default nightly >/dev/null
