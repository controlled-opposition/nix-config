{ pkgs, ... }:
let
  username = "everick";
in
{
  users.users.${username} = {
    home = "/Users/${username}";
    uid = 501;
    shell = pkgs.bashInteractive;
  };

  system.primaryUser = username;
  users.knownUsers = [ username ];
}
