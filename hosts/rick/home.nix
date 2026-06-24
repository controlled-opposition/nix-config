{ ... }:
{
  home = {
    username = "rick";
    homeDirectory = "/home/rick";
    stateVersion = "26.05";
  };

  imports = [
    ../../modules/emacs.nix
  ];

  programs = {
    home-manager.enable = true;
    git.enable = true;
    zoxide = {
      enable = true;
    };
    eza = {
      enable = true;
    };

    fzf.enable = true;
    fd.enable = true;
    nh.enable = true;
    zellij.enable = true;
    uv.enable = true;
    obsidian.enable = true;
    emacs.enable = true;
    spotify-player.enable = true;
    tmux.enable = true;
    vscode.enable = true;
  };
}
