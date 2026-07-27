{ pkgs, ... }:
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
      enableFishIntegration = true;
    };
    eza = {
      enable = true;
      enableFishIntegration = true;
    };
    discord.enable = true;
    fish.enable = true;
    fzf.enable = true;
    fd.enable = true;
    obsidian.enable = true;
    emacs.enable = true;
    tmux.enable = true;
    vscode.enable = true;
    kitty.enable = true;
    kitty.shellIntegration.enableFishIntegration = true;
    #mangohud = {
    # enable = true;
    #  enableSessionWide = false;
    #};
  };

  home.packages = with pkgs; [
    spotify
  ];

}
