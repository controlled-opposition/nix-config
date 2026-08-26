{ ... }:
{
  home = {
    username = "rick";
    homeDirectory = "/home/rick";
    stateVersion = "26.05";
  };

  imports = [
    ../../modules/agent-skills
    ../../modules/emacs
    ../../modules/nvf
    ./programs.nix
  ];
}
