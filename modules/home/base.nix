{ lib, ... }:

{
  imports = [
    ./activation.nix
    ./codex.nix
    ./files.nix
    ./fish.nix
    ./mise.nix
  ];

  home.username = "brayden";
  home.homeDirectory = "/Users/brayden";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
