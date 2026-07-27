{
  description = "a great flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
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

    nix-flatpak.url = "github:gmodena/nix-flatpak";

  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      nvf,
      determinate,
      nix-flatpak,
      ...
    }:
    {
      darwinConfigurations."Evericks-MacBook-Air" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.everick = {
                imports = [
                  nvf.homeManagerModules.default
                  ./hosts/darwin/home.nix
                  ./modules/nvf.nix
                ];
              };
            };
          }
        ];
      };

      nixosConfigurations = {

        lemon = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            determinate.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            ./hosts/lemon
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.rick = {
                  imports = [
                    nvf.homeManagerModules.default
                    ./hosts/lemon/home.nix
                    ./modules/nvf.nix
                  ];
                };
              };
            }
          ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            inputs.nixos-wsl.nixosModules.default
            ./hosts/wsl/wslConfiguration.nix
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.nixos = {
                  imports = [
                    nvf.homeManagerModules.default
                    ./hosts/wsl/home.nix
                    ./modules/nvf.nix
                  ];
                };
              };
            }
          ];
        };

      };
    };

}
