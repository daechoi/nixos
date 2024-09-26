{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-wsl = {
	url = "github:nix-community/NixOS-WSL";
	inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
	url = "github:nix-community/nixvim/nixos-24.05";
	inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
	url = "github:nix-community/home-manager/release-24.05";
	inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs @ { nixpkgs, nixos-wsl, home-manager, nixvim, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.05";
            wsl.enable = true;
	    wsl.defaultUser = "dchoi";
          }
	  ./configuration.nix
	  home-manager.nixosModules.home-manager 
	  {
		home-manager = {
			useGlobalPkgs = true;
			useUserPackages = true;
			users.dchoi = import ./home-manager;
		};
	  }
        ];
      };
    };
  };
}
