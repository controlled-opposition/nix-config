{
  description = "nix-darwin system configuration for Evericks-MacBook-Air";

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

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      determinate,
      ...
    }:
    let
      darwinSystem = "aarch64-darwin";
      wslSystem = "x86_64-linux";
      username = "everick";
      hostname = "Evericks-MacBook-Air";

      pkgs = import nixpkgs {
        system = darwinSystem;
        config.allowUnfree = true;
      };

      preCommitCheck = inputs.git-hooks.lib.${darwinSystem}.run {
        src = ./.;
        hooks = {
          nixfmt.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          check-merge-conflicts.enable = true;
          end-of-file-fixer.enable = true;
          trim-trailing-whitespace.enable = true;
        };
      };
    in
    {
      checks.${darwinSystem}.pre-commit-check = preCommitCheck;

      formatter.${darwinSystem} =
        let
          inherit (preCommitCheck) config;
          inherit (config) package configFile;
        in
        pkgs.writeShellScriptBin "pre-commit-run" ''
          ${pkgs.lib.getExe package} run --all-files --config ${configFile}
        '';

      devShells.${darwinSystem}.default = pkgs.mkShell {
        inherit (preCommitCheck) shellHook;
        buildInputs = preCommitCheck.enabledPackages;
      };

      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        system = darwinSystem;

        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/darwin/darwinConfiguration.nix
          ./hosts/darwin/homebrew.nix
        ];
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = { inherit inputs; };
        modules = [
          nvf.homeManagerModules.default
          ./hosts/darwin/home.nix
          ./hosts/nixos/home.nix
          ./modules/nvf.nix
        ];
      };

      nixosConfigurations.nixos = inputs.nixos-nixpkgs.lib.nixosSystem {
        system = wslSystem;
        modules = [
          inputs.nixos-wsl.nixosModules.default
          nvf.nixosModules.default
          ./hosts/nixos/wslConfiguration.nix
          ./modules/nvf.nix
          determinate.nixosModules.default
        ];
      };
    };
}
