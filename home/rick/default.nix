{ inputs, pkgs, ... }:
{
  imports = [ ../../modules/home/common.nix ];

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
        helix
        obsidian
        spotify
        tmux
        vscode
        zoxide
        faugus-launcher
        stow
        jujutsu
        brave-origin
        yazi
        fresh-editor
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
