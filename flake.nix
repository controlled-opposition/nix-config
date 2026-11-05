{
  description = "NixOS, WSL, and nix-darwin configurations";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    butter = {
      url = "github:microlift/butter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium-flake = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    froststrap = {
      url = "git+https://github.com/Froststrap/Froststrap?submodules=1";
    };

    laminix = {
      url = "github:jackboykin/laminix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      flake-parts,
      nix-darwin,
      nixpkgs,
      home-manager,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        { pkgs, system, ... }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          packages = pkgs.lib.filterAttrs (_: pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform) {
            claude-code-bin = pkgs.callPackage ./packages/claude-code-bin { };
            herdr-app-bin = pkgs.callPackage ./packages/herdr-app-bin { };
            herdr-bin = pkgs.callPackage ./packages/herdr-bin { };
            mise-bin = pkgs.callPackage ./packages/mise-bin { };
            nutmeg = pkgs.callPackage ./packages/nutmeg { };
            pi-bin = pkgs.callPackage ./packages/pi-bin { };
          };

          treefmt = {
            programs = {
              biome.enable = true;
              deadnix.enable = true;
              nixfmt.enable = true;
              statix.enable = true;
              taplo.enable = true;
            };
            settings.formatter.biome.options = [ "--error-on-warnings" ];
          };
        };

      flake =
        let
          linuxPkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          darwinPkgs = import nixpkgs {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
        in
        {
          homeConfigurations = {
            "rick@citrus" = home-manager.lib.homeManagerConfiguration {
              pkgs = linuxPkgs;
              extraSpecialArgs = { inherit inputs; };
              modules = [ ./home/rick ];
            };

            "weasel@rubus" = home-manager.lib.homeManagerConfiguration {
              pkgs = linuxPkgs;
              extraSpecialArgs = { inherit inputs; };
              modules = [ ./home/weasel ];
            };

            "everick@malus" = home-manager.lib.homeManagerConfiguration {
              pkgs = darwinPkgs;
              extraSpecialArgs = { inherit inputs; };
              modules = [ ./home/everick ];
            };
          };

          darwinConfigurations.malus = nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/malus ];
          };

          nixosConfigurations = {
            citrus = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = [ ./hosts/citrus ];
            };

            rubus = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = [ ./hosts/rubus ];
            };
          };
        };
    };
}
