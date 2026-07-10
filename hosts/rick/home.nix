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
      enableBashIntegration = true;
    };
    eza = {
      enable = true;
      enableBashIntegration = true;
    };
    discord.enable = true;
    bash.enable = true;
    fzf.enable = true;
    fd.enable = true;
    zellij.enable = true;
    uv.enable = true;
    obsidian.enable = true;
    emacs.enable = true;
    spotify-player.enable = true;
    tmux.enable = true;
    vscode.enable = true;
    #mangohud = {
     # enable = true;
    #  enableSessionWide = false;
    #};
  };

}
