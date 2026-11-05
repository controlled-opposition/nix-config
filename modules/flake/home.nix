{ inputs, withSystem, ... }:
let
  homeConfiguration =
    system: user:
    withSystem system (
      { pkgs, ... }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ../../home/${user} ];
      }
    );
in
{
  flake.homeConfigurations = {
    "rick@citrus" = homeConfiguration "x86_64-linux" "rick";
    "weasel@rubus" = homeConfiguration "x86_64-linux" "weasel";
    "everick@malus" = homeConfiguration "aarch64-darwin" "everick";
  };
}
