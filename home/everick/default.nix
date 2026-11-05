{ pkgs, ... }:
{
  imports = [
    ../../modules/home/common.nix
    ../../modules/home/zoxide
    ../../modules/home/emacs
  ];

  home = {
    username = "everick";
    homeDirectory = "/Users/everick";
    stateVersion = "25.11";

    packages = builtins.attrValues {

      inherit (pkgs)
        discord
        obsidian
        tmux
        zellij
        zsh
        zoom-us
        ;
    };
  };
}
