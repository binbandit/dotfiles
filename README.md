# BinBandit Dotfiles

This repository is rendered and applied by [chezmoi](https://www.chezmoi.io/). The source of truth lives under `~/.local/share/chezmoi` and is pushed to GitHub for multi-device sync. Highlights:

- **Fish shell** configuration driven by `.chezmoidata.toml` so paths, environment variables, PNPM_HOME, and work-only proxy settings stay host-aware while keeping secrets out of the repo. Background sync uses `chezmoi update` when the local watcher is unavailable.
- **Neovim & Helix** editors are configured (`dot_config/nvim`, `dot_config/helix`) with mise-managed runtimes, while Doom Emacs lives in `dot_doom.d`.
- **Terminal & editors**: Ghostty shaders/config (`dot_config/ghostty`) and Zed settings (`dot_config/zed`) are now tracked so every machine renders the same UI.
- **Language toolchains** provisioned via `rustup`, `mise`, and `uv`, with run-once scripts handling rust components, uv Python, and PNPM global packages (e.g. `@openai/codex`).
- **Automation** lives under `.chezmoiscripts` (`run_once_before`, `run_onchange_after`, `run_after`) so scripts run at the right phase without needing executable prefixes, matching chezmoi’s scripting model. The `chezmoi-sync` LaunchAgent/systemd unit keeps repositories reconciled in the background and now watches managed configs (e.g. `~/.config/nvim`, `~/.config/helix`, `~/.config/ghostty`) for changes, auto-running `chezmoi add`/`forget` before committing and pushing.
- **Manual sync helper**: A Fish function `chezsync` is available for one-off syncs. It runs `chezmoi-sync pull`/`push` (or `chezmoi update` + push fallback) so you can trigger a full round-trip with a single command.

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
   The run-once scripts will install rustup + toolchains and uv + Python automatically; rerun them from `~/.local/share/chezmoi/.chezmoiscripts/run_onchange_after/` and `run_after/` if you ever need to trigger them manually.

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

1. Tag each host in `.chezmoidata.toml` with roles and per-host data. Environment blocks such as `fish.env` let templates inject HTTP proxies and certificate bundles without hard-coding values:
   ```toml
   [hosts."EPZ-D3YJQFV0WJ"]
   roles = ["work", "mac"]

   [hosts."EPZ-D3YJQFV0WJ".fish.env]
   HTTP_PROXY = "http://localhost:3128"
   CUSTOM_CERT_BUNDLE_PATH = "/Users/Shared/ca_certs/bundle.pem"
   ```
   Fish templates merge host data with defaults so machines inherit shared paths while overriding work-only variables.
2. For entire files that should exist only on a specific host, store them under `host_<Hostname>/` via `chezmoi add --template --create=host=<Hostname> …`.
3. Use `chezmoi chattr +private …` whenever a file must never leave a machine.

Work locally inside `~/.local/share/chezmoi`, review with `chezmoi diff`, then let `chezmoi-sync` push changes or run `chezmoi update --keep-going` when you need to pull fresh state.

## Repository layout cheatsheet

- `dot_config/fish/` – templated Fish shell config, abbreviations, and completions. Host-specific paths/env come from `.chezmoidata.toml`.
- `dot_config/helix/` – Helix `config.toml` and `languages.toml` mirroring the local editor setup.
- `dot_doom.d/` – Doom Emacs `config.el`, `init.el`, and `packages.el` imported from the pre-chezmoi archive.
- `dot_config/ghostty/` – Ghostty `config` plus shader library synced from the current machine.
- `dot_config/zed/` – Zed `settings.json` and `keymap.json`.
- `.chezmoiscripts/` – Lifecycle scripts (`run_once_before`, `run_onchange_after`, `run_after`) including PNPM global installs and tooling bootstrap.

## Keeping machines in sync

- The LaunchAgent/systemd units installed via `chezmoi-sync` run `chezmoi-sync watch` so edits auto-commit and pull across hosts.
- When you need to manually reconcile with origin, run `chezmoi update --keep-going` for an idempotent pull + apply cycle.
- Run `chezmoi doctor` after large changes to confirm binaries and script hooks are ready before applying on another machine.
