{ inputs, pkgs, ... }:
{
  home-manager.users.rick = {
    imports = [ ../../modules/home/common.nix ];

    home = {
      username = "rick";
      homeDirectory = "/home/rick";
      stateVersion = "26.05";

      packages = builtins.attrValues {
        helium-flake = inputs."helium-flake".packages.${pkgs.stdenv.hostPlatform.system}.default;

        inherit (pkgs.kdePackages) dolphin;

        inherit (pkgs)
          emacs-unstable
          btop
          discord
          fastfetch
          git
          helix
          kitty
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
          direnv
          bun
          ;
      };
    };
  };
}
