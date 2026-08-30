{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };
  hjem.extraModules = [inputs.hjem-impure.hjemModules.default];
  hjem.users.everick = {
    enable = true;
    impure.enable = true;
    imports = [
      ../../modules/emacs
      ../../modules/nvf
    ];
    packages = builtins.attrValues {
      inherit (pkgs)
        discord
        fish
        git
        kitty
        micro
        nh
        obsidian
        tmux
        zellij
        zoom-us
        ;
    };
  };
}
