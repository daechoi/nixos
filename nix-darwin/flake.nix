{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixvim,
    ...
  }: let
    system = "x86_64-darwin";
    pkgs = import nixpkgs {
      inherit system;
    };
    lib = pkgs.lib;
    configuration = {...}: {
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = system;
    };
  in {
    darwinConfigurations.helium = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            verbose = true;
            users.dchoi = import ./home-manager;
            extraSpecialArgs = {inherit inputs;};
          };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations.helium.pkgs;
  };
}
