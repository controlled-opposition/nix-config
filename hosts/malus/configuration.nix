{ pkgs, ... }:

{

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      nh
      gh
      ;
  };

  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;

}
