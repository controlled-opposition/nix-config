{ ... }:
{
  home = {
    username = "weasel";
    homeDirectory = "/home/weasel";
    stateVersion = "26.05";
  };

  imports = [
    ../../modules/emacs
    ../../modules/nvf.nix
  ];

}
