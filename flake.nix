{
  description = "nix-darwin system configuration for Evericks-MacBook-Air";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

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
      ...
    }:
    let
      system = "aarch64-darwin";
      username = "everick";
      hostname = "Evericks-MacBook-Air";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      preCommitCheck = inputs.git-hooks.lib.${system}.run {
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
      checks.${system}.pre-commit-check = preCommitCheck;

      formatter.${system} =
        let
          inherit (preCommitCheck) config;
          inherit (config) package configFile;
        in
        pkgs.writeShellScriptBin "pre-commit-run" ''
          ${pkgs.lib.getExe package} run --all-files --config ${configFile}
        '';

      devShells.${system}.default = pkgs.mkShell {
        inherit (preCommitCheck) shellHook;
        buildInputs = preCommitCheck.enabledPackages;
      };

      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;

        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./homebrew.nix
        ];
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = { inherit inputs; };
        modules = [
          nvf.homeManagerModules.default
          ./home.nix
        ];
      };
    };
}
