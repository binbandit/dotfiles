{
  description = "BinBandit dotfiles with nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }:
    let
      hostData = import ./lib/hosts.nix;
      defaults = hostData.defaults;
      hosts = hostData.hosts;

      mkDarwin = hostName:
        let
          hostConfig = hosts.${hostName} or { };
          system = hostConfig.system or builtins.currentSystem;
        in
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit hostName hostConfig defaults;
          };
          modules = [
            ./modules/darwin/base.nix
            ./modules/darwin/homebrew.nix
            ./hosts/${hostName}/darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit hostName hostConfig defaults;
              };
              home-manager.users.brayden = {
                imports = [
                  ./modules/home/base.nix
                  ./hosts/${hostName}/home.nix
                ];
              };
            }
          ];
        };
    in
    {
      darwinConfigurations = {
        Braydens-MacBook-Pro = mkDarwin "Braydens-MacBook-Pro";
        EPZ-D3YJQFV0WJ = mkDarwin "EPZ-D3YJQFV0WJ";
        work-mac-template = mkDarwin "work-mac-template";
      };
    };
}
