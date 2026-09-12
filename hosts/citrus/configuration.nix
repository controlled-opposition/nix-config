{
  pkgs,
  inputs,
  lib,
  ...
}:

{

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  programs.git.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      vim
      wget
      nh
      ;
  };
  environment.variables.EDITOR = "vim";

  services.crossmacro.enable = true;
  services.crossmacro.users = [
    "rick"
  ];

  programs.fish.enable = true;

  programs.firefox.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true;

}
