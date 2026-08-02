{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    discord.enable = true;
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;
    kitty.enable = true;
    micro.enable = true;
    nh.enable = true;
    obsidian.enable = true;
    tmux.enable = true;
    zellij.enable = true;
    zoxide.enable = true;
  };

  home.packages = [ pkgs.zoom-us ];
}
