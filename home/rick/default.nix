{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };

  hjem.users.rick = {
    enable = true;
    imports = [
      ../../modules/agent-skills
     ../../modules/emacs
      ../../modules/nvf
    ];
    packages = builtins.attrValues {
      inherit (pkgs)
        btop
        discord
        eza
        fastfetch
        fd
        fish
        fzf
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
