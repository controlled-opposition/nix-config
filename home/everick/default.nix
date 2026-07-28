{ ... }:
{
  home = {
    username = "everick";
    homeDirectory = "/Users/everick";
    stateVersion = "26.05";
  };

  imports = [
    ../../modules/emacs
    ../../modules/nvf.nix
    ./programs.nix
  ];

}
