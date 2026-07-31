let
  inputs = import ./.tack;

  inherit (inputs)
    nix-darwin
    nixpkgs
    ;

  mkHjem = user: {
    hjem = {
      specialArgs = { inherit inputs; };
      users.${user} = {
        enable = true;
        imports = [
          ./home/${user}
        ];
      };
    };
  };

in
{
  darwinConfigurations."Evericks-MacBook-Air" = nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = { inherit inputs; };
    modules = [
      ./hosts/darwin
      inputs.hjem.darwinModules.default
      inputs.nix-homebrew.darwinModules.nix-homebrew
      (mkHjem "everick")
    ];
  };

  nixosConfigurations = {
    lemon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/lemon
        inputs.hjem.nixosModules.default
        inputs.nix-flatpak.nixosModules.nix-flatpak
        (mkHjem "rick")
      ];
    };

    wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/wsl
        inputs.nixos-wsl.nixosModules.default
        inputs.hjem.nixosModules.default
        (mkHjem "weasel")
      ];
    };
  };
}
