{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    discord.enable = true;
    kitty = {
      enable = true;
      extraConfig = "
      macos_option_as_alt yes
      ";
    };
    zoxide.enable = true;
    git.enable = true;
    nh.enable = true;
    bat.enable = true;
    fd.enable = true;
    fzf.enable = true;
    obsidian.enable = true;
    zellij.enable = true;
    micro.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    helix = {
      enable = true;
      settings = {
        theme = "modus_vivendi";
      };
    };
  };

  home.packages = with pkgs; [
    zoom-us
  ];
}
