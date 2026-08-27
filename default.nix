let
  inputs = import ./.tack;

  inherit (inputs)
    nix-darwin
    nixpkgs
    ;

  mkHome =
    user: system:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [];
      };
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./home/${user}
      ];
    };

in
{
  homeConfigurations = {
    everick = mkHome "everick" "aarch64-darwin";
    rick = mkHome "rick" "x86_64-linux";
    weasel = mkHome "weasel" "x86_64-linux";
  };

  darwinConfigurations."Evericks-MacBook-Air" = nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = { inherit inputs; };
    modules = [
      ./hosts/darwin
      inputs.nix-homebrew.darwinModules.nix-homebrew
    ];
  };

  nixosConfigurations = {
    lemon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/lemon
        inputs.chaotic.nixosModules.default
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];
    };

    wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/wsl
        inputs.nixos-wsl.nixosModules.default
      ];
    };
  };
}
