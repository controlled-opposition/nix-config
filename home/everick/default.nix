{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };
  hjem.users.everick = {
    enable = true;
    imports = [
      ../../modules/language-tools
      ../../modules/nvf
      ../../modules/ai
    ];
    packages = builtins.attrValues {

      inherit (pkgs)
        discord
        fish
        git
        kitty
        micro
        obsidian
        tmux
        zellij
        zoom-us
        zoxide

        gcc
        gnumake
        cmake
        nodejs_latest
        bun
        uv
        python3
        stow
        helix
        direnv
        ;
    };
  };
}
