{
  description = "a great flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    dnixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "dnixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
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
      dnixpkgs,
      nix-darwin,
      home-manager,
      nvf,
      determinate,
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
        pkgs = import dnixpkgs {
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

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          inputs.nixos-wsl.nixosModules.default
          ./hosts/nixos/wslConfiguration.nix
        ];
      };
      homeConfigurations.nixos = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
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

      nixosConfigurations.lemon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          determinate.nixosModules.default
          ./hosts/lemon/configuration.nix
          ./hosts/lemon/hardware-configuration.nix
          ./hosts/lemon/peripherals.nix
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
          ./hosts/lemon/home.nix
          ./modules/nvf.nix
        ];
      };

    };

}
