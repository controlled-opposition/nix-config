{ inputs, pkgs, ... }:
let
  emacsPkgs = pkgs.extend (import inputs.emacs-overlay);
  emacs = emacsPkgs.emacsWithPackagesFromUsePackage {
    config = ./init.el;
    package = emacsPkgs.emacs-unstable;
    alwaysEnsure = true;
  };
in
{
  packages = [ emacs ];
  files.".emacs.d/init.el".source = ./init.el;
}
