{ ... }:
{
  programs = {
    home-manager.enable = true;
    bash.enable = true;
    eza = {
      enable = true;
      enableBashIntegration = true;
    };
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;
    nh.enable = true;
    obsidian.enable = true;
    spotify-player.enable = true;
    tmux.enable = true;
    uv.enable = true;
    zellij.enable = true;
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
