{ inputs, pkgs, ... }:

{
  wsl = {
    enable = true;
    defaultUser = "weasel";
    startMenuLaunchers = true;
    useWindowsDriver = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default
    wget
    nixfmt
    nixd
    cmake
    gcc
    gnumake

  ];

  services.pulseaudio.enable = true;

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
