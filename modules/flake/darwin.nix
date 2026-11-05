{ inputs, ... }:
{
  flake.darwinConfigurations.malus = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = { inherit inputs; };
    modules = [ ../../hosts/malus ];
  };
}
