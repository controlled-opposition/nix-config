{ pkgs, ... }:

{
  wsl = {
    enable = true;
    defaultUser = "nixos";
    startMenuLaunchers = true;
    useWindowsDriver = true;
  };

  environment.systemPackages = with pkgs; [
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
