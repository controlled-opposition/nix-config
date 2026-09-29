{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/home/common.nix
    ../../modules/home/shell
    ../../modules/home/zoxide
  ];

  home = {
    username = "rick";
    homeDirectory = "/home/rick";
    stateVersion = "26.05";

    packages = builtins.attrValues {
      helium-flake = inputs."helium-flake".packages.${pkgs.stdenv.hostPlatform.system}.default;

      froststrap = inputs."froststrap".packages.${pkgs.stdenv.hostPlatform.system}.default;

      inherit (pkgs.kdePackages) dolphin;

      inherit (pkgs)
        btop
        discord
        fastfetch
        git
        obsidian
        spotify
        tmux
        vscode
        faugus-launcher
        jujutsu
        brave-origin
        yazi
        gram
        clang
        gnumake
        cmake
        libtool
        python3
        nodejs
        bun
        google-chrome
        ;
    };
  };
}
