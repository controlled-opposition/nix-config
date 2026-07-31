let
  inputs = import ./.tack;
  
  inherit (inputs)
    nix-darwin
    nixpkgs
    ;

  mkHome = user: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
      users.${user}.imports = [
        ./home/${user}
      ];
    };
  };

in
{
  darwinConfigurations."Evericks-MacBook-Air" = nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = { inherit inputs; };
    modules = [
      ./hosts/darwin
    ];
  };

  nixosConfigurations = {
    lemon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/lemon
        (mkHome "rick")
      ];
    };

    wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/wsl
        (mkHome "weasel")
      ];
    };
  };
}
