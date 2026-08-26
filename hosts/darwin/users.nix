{ pkgs, ... }:
{
  users.users.everick.home = "/Users/everick";
  users.users.everick.shell = pkgs.fish;
  system.primaryUser = "everick";
  users.knownUsers = [ "everick" ];
  users.users.everick.uid = 501;
}
