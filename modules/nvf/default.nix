{ inputs, ... }:
{
  imports = [
    inputs.nvf.homeManagerModules.default
    ./nvf.nix
  ];
}
