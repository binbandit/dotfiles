# BinBandit Dotfiles

This repository is rendered and applied by [chezmoi](https://www.chezmoi.io/). The source of truth lives under `~/.local/share/chezmoi` and is pushed to GitHub for multi-device sync. Highlights:

- **Fish shell** configuration with host-aware templating, optional corporate proxy support, and automatic `chezmoi` pull on shell startup.
- **Neovim** configuration managed via `lazy.nvim`, while `bob` handles the runtime (see `Brewfile` for dependencies).
- **Rust toolchains** provisioned through `rustup` (installed via Homebrew). The bootstrap script installs stable + nightly along with `rustfmt`, `clippy`, `rust-analyzer`, `rust-src`, docs, the `rustc-codegen-cranelift` nightly component, and the `x86_64-unknown-linux-musl` target.
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
   brew bundle --file "$HOME/Brewfile"        # macOS
   mise install                               # language runtimes
   ~/.local/bin/chezmoi-sync pull             # first sync
   ```

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

Edit templates in `~/.local/share/chezmoi`, run `chezmoi diff` to confirm changes, then commit via the sync daemon or manually with `chezmoi git` commands.
