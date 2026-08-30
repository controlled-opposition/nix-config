{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };
  hjem.extraModules = [inputs.hjem-impure.hjemModules.default];
  hjem.users.rick = {
    enable = true;
    impure.enable = true;
    imports = [
      ../../modules/agent-skills
   #  ../../modules/emacs
      ../../modules/nvf
      ../../modules/fish
      ../../modules/kitty
    ];
    packages = builtins.attrValues {
      inherit (pkgs)
        btop
        discord
        fastfetch
        fish
        git
        helix
        kitty
        nil
        obsidian
        spotify
        tmux
        vscode
        zed-editor
        zoxide
        ;
    };
  };
}
