{ config, lib, pkgs, hostName, ... }:

{
  networking.hostName = hostName;
  networking.computerName = hostName;
  networking.localHostName = hostName;

  nix.package = pkgs.lix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.nix-daemon.enable = true;

  # security - touch id for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  programs.fish.enable = true;

  users.users.brayden = {
    home = "/Users/brayden";
    shell = pkgs.fish;
  };

  environment.shells = [ pkgs.fish ];

  system.stateVersion = 5;
}
