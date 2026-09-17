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
    files = {
      ".pi/agent/settings.json".source = ../../dotfiles/.pi/agent/settings.json;
    };
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
        ;
    };
  };
}
