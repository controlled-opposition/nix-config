{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.dolphin-emu ];

  services.udev.packages = [ pkgs.dolphin-emu ];

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
}
