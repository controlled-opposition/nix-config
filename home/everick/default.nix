{ pkgs, ... }:
{
  imports = [ ../../modules/home/common.nix ];

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
        zoom-us
        zoxide
        mise

        nodejs
        bun
        python3
        gcc
        gnumake
        cmake
        stow
        helix
        ripgrep
        fd
        ;
    };
  };
}
