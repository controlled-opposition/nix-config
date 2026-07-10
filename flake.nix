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
    {
      darwinConfigurations."Evericks-MacBook-Air" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/darwin/darwinConfiguration.nix
          ./hosts/darwin/homebrew.nix
        ];
      };
      homeConfigurations.everick = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [
          nvf.homeManagerModules.default
          ./hosts/darwin/home.nix
          ./modules/nvf.nix
        ];
      };

      nixosConfigurations.nixos = inputs.nixos-nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.nixos-wsl.nixosModules.default
          ./hosts/nixos/wslConfiguration.nix
        ];
      };
      homeConfigurations.nixos = home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixos-nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [
          nvf.homeManagerModules.default
          ./hosts/nixos/home.nix
          ./modules/nvf.nix
        ];
      };

      nixosConfigurations.lemon = inputs.nixos-nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/rick/configuration.nix
          ./hosts/rick/hardware-configuration.nix
          ./hosts/rick/nvidia.nix
          ./hosts/rick/peripherals.nix
        ];
      };
      homeConfigurations.rick = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [
          nvf.homeManagerModules.default
          ./hosts/rick/home.nix
          ./modules/nvf.nix
        ];
      };

    };

}
