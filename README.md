# BinBandit Dotfiles

Declarative dotfile management via [mimic](https://github.com/binbandit/mimic). Manages symlinks, Homebrew packages, host-specific config with Handlebars templates, and activation hooks for runtimes and tools.

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
```

## Daily usage

```bash
rebuild   # fish function: runs mimic apply
```

## Host-specific configuration

Host overrides are defined in `mimic.toml` under `[hosts.<hostname>]`. Each host has roles and variable overrides. Templates use `{{#if (includes host.roles "work")}}` for conditional blocks.

Current hosts:
- `Braydens-MacBook-Pro` — personal
- `EPZ-D3YJQFV0WJ` — work (proxy, certs, litellm)

mimic auto-detects the hostname at apply time.

## Repository layout

```
mimic.toml              # Main config: variables, dotfiles, packages, hosts, hooks
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
  bootstrap.sh          # Fresh machine setup (brew + rust + mimic + apply)
```

## Notes

- Homebrew packages are declared in `mimic.toml` under `[packages]`.
- Runtime setup (mise, uv, rustup, cargo tools, fisher) runs via `[[hooks]]` in `mimic.toml` during `mimic apply`.
- Git identity is rendered to `~/.config/git/local.conf` from `templates/git/local.conf.hbs`, with per-host overrides in `mimic.toml`.
