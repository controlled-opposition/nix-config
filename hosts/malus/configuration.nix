{ pkgs, ... }:

{

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
        vim
        wget
        nh
      ;
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

}
