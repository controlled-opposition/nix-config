{ pkgs, ... }:
{
  
  programs.niri.enable = true;

  # GNOME's portal delegates FileChooser requests to Nautilus. Register its
  # D-Bus service so browser save/open dialogs can be activated under niri.
  services.dbus.packages = with pkgs; [
    nautilus
  ];

  # Niri starts Xwayland Satellite on demand when it is available in PATH.
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ]; 

  # The upstream NixOS module supplies niri's Home Manager config module.
  home-manager.sharedModules = [
    ./home.nix
  ];
}
