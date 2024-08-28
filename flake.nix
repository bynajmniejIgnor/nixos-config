{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations = { 
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
	  inputs.home-manager.nixosModules.default
	  inputs.nixvim.nixosModules.nixvim
          ./configuration.nix
	  ./desktop/i3.nix
	  ./texteditor/nixvim.nix
        ];
      };
    };
  };
}
