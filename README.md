# BinBandit Dotfiles

Declarative dotfile management via [mimic](https://github.com/binbandit/mimic). Manages symlinks, Homebrew packages, and host-specific config with Handlebars templates.

Default location on disk: `~/.dots`

## Quick start (macOS)

One-liner bootstrap:

```bash
curl -fsSL https://raw.githubusercontent.com/binbandit/dotfiles/main/scripts/bootstrap.sh | bash
```

Or manually:

```bash
git clone git@github.com:binbandit/dotfiles.git ~/.dots
cd ~/.dots
mimic apply --config mimic.toml
bash scripts/post-apply.sh
```

## Daily usage

```bash
rebuild   # fish function: runs mimic apply + post-apply.sh
```

## Host-specific configuration

Host overrides are defined in `mimic.toml` under `[hosts.<hostname>]`. Each host has roles and variable overrides. Templates use `{{#if (includes host.roles "work")}}` for conditional blocks.

Current hosts:
- `Braydens-MacBook-Pro` — personal
- `EPZ-D3YJQFV0WJ` — work (proxy, certs, litellm)

mimic auto-detects the hostname at apply time.

## Repository layout

```
mimic.toml              # Main config: variables, dotfiles, packages, hosts
dotfiles/               # Static dotfiles (symlinked into $HOME)
  config/               # XDG config dirs (nvim, fish, ghostty, tmux, etc.)
  gitconfig             # ~/.gitconfig
  doom.d/               # Emacs Doom config
  claude/commands/      # Claude Code custom commands
templates/              # Handlebars templates (rendered at apply time)
  fish/                 # Shell init, host env, keychain secrets
  mise/                 # mise tool declarations
  codex/                # Codex config (work vs personal)
scripts/
  bootstrap.sh          # Fresh machine setup (brew + mimic + apply)
  post-apply.sh         # Runtime setup (mise, uv, rustup, cargo tools, fisher)
```

## Notes

- Homebrew packages are declared in `mimic.toml` under `[packages]`.
- Post-apply tasks (mise install, rustup, cargo tools, fisher) run via `scripts/post-apply.sh`.
- Git config includes a local file at `~/.config/git/local.conf` for per-device overrides.
