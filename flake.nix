{
  description = "nix-darwin system configuration for Evericks-MacBook-Air";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin.url = "github:nix-darwin/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixos-nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    den.url = "github:vic/den";

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
      ...
    }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      denConfig =
        (nixpkgs.lib.evalModules {
          modules = [ ./modules/den.nix ];
          specialArgs = { inherit inputs; };
        }).config;

      preCommitChecks = forAllSystems (
        system:
        inputs.git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            deadnix.enable = true;
            statix.enable = true;
            check-merge-conflicts.enable = true;
            end-of-file-fixer.enable = true;
            trim-trailing-whitespace.enable = true;
          };
        }
      );
    in
    builtins.removeAttrs denConfig.flake [ "denful" ]
    // {
      checks = nixpkgs.lib.mapAttrs (_: preCommitCheck: {
        pre-commit-check = preCommitCheck;
      }) preCommitChecks;

      formatter = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          preCommitCheck = preCommitChecks.${system};
          inherit (preCommitCheck) config;
          inherit (config) package configFile;
        in
        pkgs.writeShellScriptBin "pre-commit-run" ''
          ${pkgs.lib.getExe package} run --all-files --config ${configFile}
        ''
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          preCommitCheck = preCommitChecks.${system};
        in
        {
          default = pkgs.mkShell {
            inherit (preCommitCheck) shellHook;
            buildInputs = preCommitCheck.enabledPackages;
          };
        }
      );
    };
}
