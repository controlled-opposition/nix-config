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

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 3";
    };

  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      vim
      wget
      google-chrome
      faugus-launcher
      stow

      clang
      gnumake
      cmake
      libtool
      python3
      nodejs_latest
      direnv
      ;
  };

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
