{ ... }:

let
  username = "everick";
in
{
  users.users.${username} = {
    home = "/Users/${username}";
    uid = 501;
  };

  system.primaryUser = username;
  users.knownUsers = [ username ];
}
