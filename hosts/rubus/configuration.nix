{ inputs, pkgs, ... }:

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
      vim
      wget
      cmake
      gcc
      gnumake
      stow
      ;

  };

  services.pulseaudio.enable = true;

  environment.variables.EDITOR = "vim";

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
