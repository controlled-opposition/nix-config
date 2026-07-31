{ pkgs, ... }:
{
  packages = [ (pkgs.emacs.pkgs.withPackages (_: [ ])) ];

  files.".emacs.d/init.el" = {
    source = ./init.el;
    clobber = true;
  };
}
