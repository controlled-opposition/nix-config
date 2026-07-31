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

    obsidian
    zoom-us
    kitty
    discord
    zoxide
    git
    nh
    bat
    fd
    fzf
    zellij
    micro
    tmux
  ];
  fonts.packages = with pkgs; [
    iosevka-bin
  ];

}
