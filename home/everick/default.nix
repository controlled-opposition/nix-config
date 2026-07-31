{ inputs, ... }:
{
  home = {
    username = "everick";
    homeDirectory = "/Users/everick";
    stateVersion = "26.05";
  };

  imports = [
    inputs.nvf.homeManagerModules.default
    ../../modules/emacs
    ../../modules/nvf
    ./programs.nix
  ];

}
