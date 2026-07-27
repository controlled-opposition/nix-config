{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "Evericks-MacBook-Air";

  users.users.everick.home = "/Users/everick";
  system.primaryUser = "everick";

  system = {
    stateVersion = 6;
  };

  environment.systemPackages = with pkgs; [
    inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default
    gcc
    gnumake
    cmake
    nodejs
    bun
    nixd
    nixfmt
    nil
    uv
    python3
    alejandra
    statix
  ];
  fonts.packages = with pkgs; [
    iosevka-bin
  ];

}
