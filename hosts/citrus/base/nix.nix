{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.auto-optimise-store = true;
  nix.package = pkgs.nix;
  system.stateVersion = "26.05";

}
