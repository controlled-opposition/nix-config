{ pkgs, ... }:
{
  imports = [ ../../modules/home/common.nix ];

  home = {
    username = "weasel";
    homeDirectory = "/home/weasel";
    stateVersion = "25.11";

    packages = builtins.attrValues {
      inherit (pkgs)
        git
        jujutsu
        nh
        obsidian
        spotify-player
        tmux
        uv
        zellij
        ;
    };
  };
}
