{ pkgs, ... }:

{

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      gcc
      gnumake
      cmake
      nodejs_latest
      bun
      uv
      python3
      nh
      docker
      stow
      helix
      direnv
      ;
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

}
