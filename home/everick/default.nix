{ pkgs, ... }:
{
  imports = [
    ../../modules/home/common.nix
    ../../modules/home/zoxide
  ];

  home = {
    username = "everick";
    homeDirectory = "/Users/everick";
    stateVersion = "25.11";

    packages = builtins.attrValues {

      inherit (pkgs)
        discord
        git
        micro
        obsidian
        tmux
        zellij
        zsh
        zoom-us

        nodejs
        bun
        python3
        gcc
        gnumake
        cmake
        ripgrep
        fd
        ;
    };
  };
}
