{ inputs, ... }:
let
  nixosSystem =
    host:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ../../hosts/${host} ];
    };
in
{
  flake.nixosConfigurations = {
    citrus = nixosSystem "citrus";
    rubus = nixosSystem "rubus";
  };
}
