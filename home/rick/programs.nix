{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    discord.enable = true;
    eza = {
      enable = true;
      enableFishIntegration = true;
    };
    fastfetch.enable = true;
    fd.enable = true;
    fish.enable = true;
    fzf.enable = true;
    git.enable = true;
    helix = {
      enable = true;
      settings.theme = "modus_vivendi";
    };
    kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
    };
    obsidian.enable = true;
    tmux.enable = true;
    vscode.enable = true;
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    zed-editor.enable = true;
    btop.enable = true;
  };

  home.packages = builtins.attrValues {
    inherit (pkgs)
      spotify
      nil
      ;
  };
}
