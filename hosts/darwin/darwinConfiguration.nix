{ pkgs, inputs, ... }:

{

  networking.hostName = "Evericks-MacBook-Air";

  environment.systemPackages = builtins.attrValues {
    tack = inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default;
    
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
      ;
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

}
