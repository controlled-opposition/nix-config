{ pkgs, ... }:
{
  hjem.users.everick = {
    enable = true;
    imports = [ ../../modules/hjem/common.nix ];
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
}
