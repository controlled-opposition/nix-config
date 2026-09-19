{ inputs, pkgs, ... }:
{
  packages = [
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [ ./nvf.nix ];
    }).neovim
  ];
}
