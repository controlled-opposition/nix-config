{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };
  hjem.extraModules = [inputs.hjem-impure.hjemModules.default];
  hjem.users.everick = {
    enable = true;
    impure.enable = true;
    imports = [
     # ../../modules/emacs
      ../../modules/nvf
     #  ../../modules/agent-skills
      ../../modules/fish
      ../../modules/kitty
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
        ;
    };
  };
}
