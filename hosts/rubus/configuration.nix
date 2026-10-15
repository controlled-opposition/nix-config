{ pkgs, ... }:

{
  networking.hostName = "rubus";

  nix.settings = {
    # Artifacts of the nix-community inputs used by this host.
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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
      ;

  };

  services.pulseaudio.enable = true;

  programs.nix-ld.enable = true;

  system.stateVersion = "25.11";
}
