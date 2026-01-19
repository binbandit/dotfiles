{ lib, defaults, ... }:

let
  uvVersion = (defaults.uv or { }).pythonVersion or "3.12";
  pnpmGlobals = (defaults.pnpm or { }).globalPackages or [ ];
  cargoTools = defaults.cargoTools or [ ];

  pnpmList = lib.concatStringsSep " " (map lib.escapeShellArg pnpmGlobals);
  cargoEntries = lib.concatStringsSep " " (map (tool:
    lib.escapeShellArg ("name=${tool.name} git=${tool.git}" + lib.optionalString (tool ? bin) " bin=${tool.bin}")
  ) cargoTools);
in
{
  home.activation.miseInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v mise >/dev/null 2>&1; then
      mise install >/dev/null 2>&1 || true
    fi
  '';

  home.activation.uvPython = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! command -v uv >/dev/null 2>&1; then
      exit 0
    fi

    mkdir -p "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"

    uv python install "${uvVersion}" >/dev/null 2>&1 || true

    PY_BIN="$(uv python find "${uvVersion}" 2>/dev/null || true)"
    if [ -n "$PY_BIN" ] && [ -x "$PY_BIN" ]; then
      ln -sf "$PY_BIN" "$HOME/.local/bin/python"
      ln -sf "$PY_BIN" "$HOME/.local/bin/python3"

      PIP_BIN="$(dirname "$PY_BIN")/pip3"
      if [ -x "$PIP_BIN" ]; then
        ln -sf "$PIP_BIN" "$HOME/.local/bin/pip"
        ln -sf "$PIP_BIN" "$HOME/.local/bin/pip3"
      fi
    fi
  '';

  home.activation.rustupSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! command -v rustup >/dev/null 2>&1; then
      if command -v rustup-init >/dev/null 2>&1; then
        rustup-init -y --default-toolchain stable >/dev/null 2>&1 || true
      else
        exit 0
      fi
    fi

    export PATH="$HOME/.cargo/bin:$PATH"

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
  '';

  home.activation.cargoTools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! command -v cargo >/dev/null 2>&1; then
      exit 0
    fi

    tools=(${cargoEntries})
    for entry in "${tools[@]}"; do
      unset name git bin
      eval "$entry"
      if [ -z "${name:-}" ] || [ -z "${git:-}" ]; then
        continue
      fi

      args=(install "$name" --git "$git" --locked)
      if [ -n "${bin:-}" ]; then
        args+=(--bin "$bin")
      fi

      if cargo install --list 2>/dev/null | grep -q "^${name} "; then
        cargo "${args[@]}" --force >/dev/null 2>&1 || true
      else
        cargo "${args[@]}" >/dev/null 2>&1 || true
      fi
    done
  '';

  home.activation.pnpmGlobals = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! command -v pnpm >/dev/null 2>&1; then
      exit 0
    fi

    : "''${PNPM_HOME:=$HOME/Library/pnpm}"
    export PNPM_HOME
    if ! printf '%s' "$PATH" | tr ':' '\n' | grep -Fx "$PNPM_HOME" >/dev/null 2>&1; then
      export PATH="$PNPM_HOME:$PATH"
    fi
    mkdir -p "$PNPM_HOME"

    PACKAGES=(${pnpmList})
    if [ ''${#PACKAGES[@]} -eq 0 ]; then
      exit 0
    fi

    for pkg in "''${PACKAGES[@]}"; do
      if ! pnpm ls -g --depth 0 "$pkg" >/dev/null 2>&1; then
        pnpm add -g "$pkg"
      fi
    done
  '';
}
