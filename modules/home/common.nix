{ inputs, ... }:
{
  imports = [
    inputs.nvf.homeManagerModules.default
    ./language-tools
    ./kitty
    ./nvf
    ./ai
    ./pi
    ./skills
    ./direnv
  ];
}
