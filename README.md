# BinBandit Dotfiles (Nix)

This repo is now a nix-darwin + home-manager flake. It manages:

- Homebrew packages via nix-darwin
- Dotfiles and shell/editor config via home-manager
- Host-specific paths, env, and work-only settings

## Quick start (macOS)

1. Install Nix (multi-user install recommended).
2. Clone the repo and switch:

```bash
git clone git@github.com:binbandit/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
nix run github:LnL7/nix-darwin -- switch --flake .#Braydens-MacBook-Pro
```

Replace the flake target with your host name (see `flake.nix`).

## Host-specific configuration

- Defaults and per-host settings live in `lib/hosts.nix`.
- Each host has its own overrides in `hosts/<hostname>/darwin.nix` and
  `hosts/<hostname>/home.nix`.

To add a new machine:

1. Copy `hosts/work-mac-template` to `hosts/<new-hostname>`.
2. Add the host to `lib/hosts.nix`.
3. Add the host to `flake.nix` under `darwinConfigurations`.

## Repository layout

- `flake.nix` - entrypoint for nix-darwin + home-manager
- `modules/darwin` - system-level configuration (nix, homebrew, shell)
- `modules/home` - home-manager modules (fish, mise, codex, activation tasks)
- `files/` - tracked dotfiles linked into `$HOME`
- `hosts/` - per-host overrides

## Notes

- Homebrew is managed declaratively. Do not edit a Brewfile manually.
- Post-activation tasks for mise, rustup, uv, and pnpm globals are handled by
  home-manager activation hooks.
- Run `nix flake update` to update pinned inputs.
