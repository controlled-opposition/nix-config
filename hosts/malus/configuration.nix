{ pkgs, ... }:

{

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
        vim
        wget
      ;
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

}
