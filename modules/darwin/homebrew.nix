{ config, lib, ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [
      "fish"
      "tmux"
      "fzf"
      "ripgrep"
      "fd"
      "bat"
      "starship"
      "zoxide"
      "direnv"
      "mise"
      "fswatch"
      "sesh"
      "lazygit"
      "jq"
      "eza"
      "git-delta"
      "openssl@3"
      "node"
      "pnpm"
      "python@3.12"
      "go"
      "gnu-sed"
      "coreutils"
      "rustup-init"
      "uv"
    ];
  };
}
