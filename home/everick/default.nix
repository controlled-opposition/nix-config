{ pkgs, ... }:
{
  home-manager.users.everick = {
    imports = [ ../../modules/home/common.nix ];

    home = {
      username = "everick";
      homeDirectory = "/Users/everick";
      stateVersion = "25.11";

      packages = builtins.attrValues {

        inherit (pkgs)
          emacs
          discord
          git
          kitty
          micro
          obsidian
          tmux
          zellij
          zoom-us
          zoxide

          nodejs
          bun
          python3
          gcc
          gnumake
          cmake
          stow
          helix
          direnv
          ripgrep
          fd
          ;
      };
    };
  };
}
