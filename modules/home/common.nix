{ inputs, ... }:
{
  imports = [
    inputs.nvf.homeManagerModules.default
    ./language-tools
    ./nvf
    ./ai
    ./pi
    ./skills
  ];
}
