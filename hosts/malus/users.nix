{ pkgs, ... }:
{
  users.users.everick.home = "/Users/everick";
  system.primaryUser = "everick";
  users.knownUsers = [ "everick" ];
  users.users.everick.uid = 501;

  users.users.everick.shell = pkgs.fish;
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

}
