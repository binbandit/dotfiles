# BinBandit Dotfiles

This repository is rendered and applied by [chezmoi](https://www.chezmoi.io/). The source of truth lives under `~/.local/share/chezmoi` and is pushed to GitHub for multi-device sync. Highlights:

- **Fish shell** configuration with host-aware templating, optional corporate proxy support, and automatic `chezmoi` pull on shell startup.
- **Neovim** configuration managed via `lazy.nvim`, while `bob` handles the runtime (see `Brewfile` for dependencies).
- **Tmux** theme + helper scripts with cross-platform clipboard handling.
- **Automation** scripts:
  - `chezmoi-sync` background daemon (LaunchAgent on macOS, systemd user service on Linux) that commits & pushes changes and keeps machines in sync.
  - Run-once helpers to bootstrap Homebrew/Arch packages and install custom Cargo binaries.

Edit templates in `~/.local/share/chezmoi`, run `chezmoi diff` to confirm changes, then commit via the sync daemon or manually with `chezmoi git` commands.
