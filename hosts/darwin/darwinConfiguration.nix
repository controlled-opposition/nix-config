{ pkgs, inputs, ... }:

{

  networking.hostName = "Evericks-MacBook-Air";

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
