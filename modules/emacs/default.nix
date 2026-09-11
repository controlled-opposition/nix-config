{ inputs, pkgs, ... }:
let
  emacsPkgs = pkgs.extend (import inputs.emacs-overlay);
in
{
  packages = [ emacsPkgs.emacs-unstable ];
}
