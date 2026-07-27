let
  inputs = import ./.tack;
  inherit (inputs)
    home-manager
    nix-darwin
    nix-flatpak
    nixpkgs
    nvf
    ;

in
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
}
