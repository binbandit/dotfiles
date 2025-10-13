# BinBandit Dotfiles

This repository is rendered and applied by [chezmoi](https://www.chezmoi.io/). The source of truth lives under `~/.local/share/chezmoi` and is pushed to GitHub for multi-device sync. Highlights:

- **Fish shell** configuration with host-aware templating, optional corporate proxy support, and automatic `chezmoi` pull on shell startup.
- **Neovim** configuration managed via `lazy.nvim`, while `bob` handles the runtime (see `~/.config/homebrew/Brewfile` for dependencies).
- **Rust toolchains** provisioned through `rustup` (installed via Homebrew). The bootstrap script installs stable + nightly along with `rustfmt`, `clippy`, `rust-analyzer`, `rust-src`, docs, the `rustc-codegen-cranelift` nightly component, and the `x86_64-unknown-linux-musl` target.
- **Python** is supplied via [uv](https://github.com/astral-sh/uv) (no `python@…` Homebrew formula). A run-once installer fetches uv and installs the pinned CPython version (default `3.12`) with `python`/`pip` symlinked into `~/.local/bin`.
- **Tmux** theme + helper scripts with cross-platform clipboard handling.
- **Automation** scripts:
  - `chezmoi-sync` background daemon (LaunchAgent on macOS, systemd user service on Linux) that commits & pushes changes and keeps machines in sync.
  - Run-once helpers to bootstrap Homebrew/Arch packages, set up rustup toolchains/components, and install custom Cargo binaries.

## Quick bootstrap

On a brand-new machine:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/binbandit/dotfiles/main/scripts/bootstrap.sh)"
```

The script:

1. Installs prerequisites (Homebrew on macOS, `git/chezmoi` on Arch and Debian-based distros).
2. Runs `chezmoi init --apply binbandit` to materialise the dotfiles.
3. Performs an initial `~/.local/bin/chezmoi-sync pull` if the watcher is available.

## Manual setup (if you prefer to run commands yourself)

1. Ensure `git` and `chezmoi` are installed. On macOS:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   brew install chezmoi git
   ```
   On Arch:
   ```bash
   sudo pacman -Sy --needed --noconfirm git chezmoi
   ```
   On Debian/Ubuntu:
   ```bash
   sudo apt-get update && sudo apt-get install -y git curl
   sh -c "$(curl -fsSL https://chezmoi.io/get)" -- -b "$HOME/.local/bin"
   export PATH="$HOME/.local/bin:$PATH"
   ```

2. Initialise and apply the dotfiles:
   ```bash
   chezmoi init --apply binbandit
   ```

3. Install tools (after `chezmoi apply`):
   ```bash
   brew bundle --file "$HOME/.config/homebrew/Brewfile"  # macOS
   mise install                               # language runtimes
   ~/.local/bin/chezmoi-sync pull             # first sync
   ```
   The run-once scripts will install rustup + toolchains and uv + Python automatically; rerun them manually if you ever need to (see `~/.local/share/chezmoi/executable_run_once_after_*.sh.tmpl`).

4. Enable the sync daemon:
   - **macOS**:
     ```bash
     launchctl bootout gui/$(id -u) com.binbandit.chezmoi-sync 2>/dev/null || true
     launchctl bootstrap gui/$(id -u) "$HOME/Library/LaunchAgents/com.binbandit.chezmoi-sync.plist"
     launchctl enable gui/$(id -u)/com.binbandit.chezmoi-sync
     launchctl kickstart -k gui/$(id -u)/com.binbandit.chezmoi-sync
     ```
   - **Arch/Linux (systemd)**:
     ```bash
     systemctl --user daemon-reload
     systemctl --user enable --now chezmoi-sync.service
   systemctl --user enable --now chezmoi-sync-pull.timer
    ```

Edit templates in `~/.local/share/chezmoi`, run `chezmoi diff` to confirm changes, then commit via the sync daemon or manually with `chezmoi git` commands.

## Host-specific/work-only configuration

To keep corporate or machine-only settings in sync across work devices without affecting personal machines:

1. Tag each host in `.chezmoidata.toml`:
   ```toml
   [hosts."Work-MBP"]
   roles = ["work", "mac"]

   [hosts."Work-Studio"]
   roles = ["work", "mac"]
   ```
2. Gate templates or config snippets on the `work` role, e.g.:
   ```fish
   {{- $host := index .chezmoidata.hosts .chezmoi.hostname | default dict -}}
   {{- if and $host (has $host.roles "work") }}
   # Work-only Fish config
   set -gx HTTP_PROXY "http://proxy.corp:8080"
   {{- end }}
   ```
3. For entire files that should exist only on work hosts, store them in `host_Work-MBP/` etc. (`chezmoi add --template --create=host=Work-MBP …`).
4. Use `chezmoi chattr +private …` when a file must stay local to a single machine.

Follow the usual workflow—edit on the destination, `chezmoi add …`, then commit—knowing that only hosts matching the role render those sections.

Edit templates in `~/.local/share/chezmoi`, run `chezmoi diff` to confirm changes, then commit via the sync daemon or manually with `chezmoi git` commands.
