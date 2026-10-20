{ pkgs, ... }:

{

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      nh
      gh
      ;
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.zsh ];

}
