{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlays.default
  ];

  services.emacs.package = pkgs.emacs-unstable;
}
