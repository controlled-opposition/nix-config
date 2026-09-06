{ pkgs, inputs, ... }:

{

  networking.hostName = "Evericks-MacBook-Air";

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
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
      docker
      stow
      ;
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

}
