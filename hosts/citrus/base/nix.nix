{ pkgs, ... }:
{
  nix.settings.auto-optimise-store = true;
  nix.package = pkgs.nix;
  system.stateVersion = "26.05";

}
