{ pkgs, ... }:

{
  networking.hostName = "rubus";

  wsl = {
    enable = true;
    defaultUser = "weasel";
    startMenuLaunchers = true;
    useWindowsDriver = true;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      cmake
      gcc
      gnumake
      stow
      ;

  };

  services.pulseaudio.enable = true;

  programs.nix-ld.enable = true;

  system.stateVersion = "25.11";
}
