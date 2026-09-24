{ pkgs, ... }:
{
  programs.nvf = {
    enable = true;
    settings = import ./nvf.nix { inherit pkgs; };
  };
}
