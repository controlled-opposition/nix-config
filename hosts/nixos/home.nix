{ ... }:
{
  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    stateVersion = "26.05";
  };

  imports = [
    ../../modules/jujutsu.nix
  ];

  programs.home-manager.enable = true;
}
