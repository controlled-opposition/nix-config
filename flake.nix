{
  description = "NixOS, WSL, and nix-darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    noctalia.url = "github:noctalia-dev/noctalia";

    umbriel = {
      url = "github:noctalia-dev/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium-flake = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic.url = "github:chaotic-cx/nyx";

    llm-agents.url = "github:numtide/llm-agents.nix";

    hermes-agent.url = "github:NousResearch/hermes-agent";

    autolith.url = "github:lambda-symbolics/autolith";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nix-darwin,
      nixpkgs,
      ...
    }:
    {
      darwinConfigurations.malus = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/malus
          ./home/everick
          ./modules/fonts
          inputs.hjem.darwinModules.default
          inputs.nix-homebrew.darwinModules.nix-homebrew
        ];
      };

      nixosConfigurations = {
        citrus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/citrus
            ./home/rick
            inputs.chaotic.nixosModules.default
            inputs.hjem.nixosModules.default
            inputs.nix-flatpak.nixosModules.nix-flatpak
          ];
        };

        rubus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/rubus
            ./home/weasel
            inputs.hjem.nixosModules.default
            inputs.nixos-wsl.nixosModules.default
          ];
        };
      };
    };
}
