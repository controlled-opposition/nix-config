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
    uv
    python3
    alejandra
    statix
    nh
  ];

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

}
