let
  inputs = import ./.tack;

  inherit (inputs)
    nix-darwin
    nixpkgs
    ;
in
{
  darwinConfigurations."Evericks-MacBook-Air" = nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = { inherit inputs; };
    modules = [
      ./hosts/darwin
      ./home/everick
      ./modules/fonts
      inputs.hjem.darwinModules.default
      inputs.nix-homebrew.darwinModules.nix-homebrew
    ];
  };

  nixosConfigurations = {
    lemon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/lemon
        ./home/rick
        inputs.chaotic.nixosModules.default
        inputs.hjem.nixosModules.default
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];
    };

    wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/wsl
        ./home/weasel
        inputs.hjem.nixosModules.default
        inputs.nixos-wsl.nixosModules.default
      ];
    };
  };
}
