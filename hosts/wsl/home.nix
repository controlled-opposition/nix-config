{ ... }:
{
  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    stateVersion = "26.05";
  };

  imports = [
    ../../modules/emacs
  ];

  programs = {
    home-manager.enable = true;
    git.enable = true;
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
    eza = {
      enable = true;
      enableBashIntegration = true;
    };

    fzf.enable = true;
    fd.enable = true;
    nh.enable = true;
    zellij.enable = true;
    uv.enable = true;
    bash.enable = true;
    obsidian.enable = true;
    emacs.enable = true;
    spotify-player.enable = true;
    tmux.enable = true;
  };
}
