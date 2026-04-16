{ pkgs, ... }:
{
  home = {
    username = "everick";
    homeDirectory = "/Users/everick";
    stateVersion = "26.05";
  };

  imports = [
    ./nvf.nix
  ];

  programs = {
    home-manager.enable = true;
    discord.enable = true;
    kitty = {
      enable = true;
      extraConfig = "
      macos_option_as_alt yes
      ";
    };
    emacs.enable = true;
    zoxide.enable = true;
    git.enable = true;
    nh.enable = true;
    codex.enable = true;
    bat.enable = true;
    fd.enable = true;
    fzf.enable = true;
    obsidian.enable = true;
    zellij.enable = true;
    micro.enable = true;
    tmux.enable = true;
    yazi.enable = true;
  };

  home.packages = with pkgs; [
    zoom-us
    spotify
  ];

}
