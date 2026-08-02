{ ... }:
{
  home = {
    username = "rick";
    homeDirectory = "/home/rick";
    stateVersion = "26.05";
  };

  imports = [
    ../../modules/emacs
    ../../modules/nvf
    ./programs.nix
  ];
}
