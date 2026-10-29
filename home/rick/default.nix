{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/home/common.nix
    ../../modules/home/zoxide
    ../../modules/home/emacs
  ];

  home = {
    username = "rick";
    homeDirectory = "/home/rick";
    stateVersion = "26.05";

    packages = builtins.attrValues {
      helium-flake = inputs."helium-flake".packages.${pkgs.stdenv.hostPlatform.system}.default;

      froststrap = inputs."froststrap".packages.${pkgs.stdenv.hostPlatform.system}.default;

      inherit (pkgs)
        btop
        discord
        fastfetch
        obsidian
        spotify
        tmux
        vscode
        faugus-launcher
        jujutsu
        brave-origin
        yazi
        zsh
        gram
        clang
        gnumake
        cmake
        libtool
        python3
        google-chrome
        unsloth-desktop
        ;
    };
  };
}
