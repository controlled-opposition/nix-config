{
  description = "a great flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixos-nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

 

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      nvf,
      ...
    }:
    let
      darwinSystem = "aarch64-darwin";
      wslSystem = "x86_64-linux";
      darwinUsername = "everick";
      wslUsername = "nixos";
      hostname = "Evericks-MacBook-Air";

      darwinPkgs = import nixpkgs {
        system = darwinSystem;
        config.allowUnfree = true;
      };

      wslPkgs = import inputs.nixos-nixpkgs {
        system = wslSystem;
        config.allowUnfree = true;
      };
    in
    {
      devShells.${darwinSystem}.default = darwinPkgs.mkShell { };

      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        system = darwinSystem;

        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/darwin/darwinConfiguration.nix
          ./hosts/darwin/homebrew.nix
        ];
      };

      homeConfigurations.${darwinUsername} = home-manager.lib.homeManagerConfiguration {
        pkgs = darwinPkgs;

        extraSpecialArgs = { inherit inputs; };
        modules = [
          nvf.homeManagerModules.default
          ./hosts/darwin/home.nix
          ./modules/nvf.nix
        ];
      };

      homeConfigurations.${wslUsername} = home-manager.lib.homeManagerConfiguration {
        pkgs = wslPkgs;

        extraSpecialArgs = { inherit inputs; };
        modules = [
          nvf.homeManagerModules.default
          ./hosts/nixos/home.nix
          ./modules/nvf.nix
        ];
      };

      nixosConfigurations.nixos = inputs.nixos-nixpkgs.lib.nixosSystem {
        system = wslSystem;
        modules = [
          inputs.nixos-wsl.nixosModules.default
          ./hosts/nixos/wslConfiguration.nix
        ];
      };
    };
}
