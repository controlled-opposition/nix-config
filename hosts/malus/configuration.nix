{ pkgs, ... }:

{

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      vim
      wget
      nh
      gh
      ;
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
  environment.variables.EDITOR = "vim";

}
