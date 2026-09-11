{ pkgs, ... }:

let
  username = "everick";
in
{
  users.users.${username} = {
    home = "/Users/${username}";
    uid = 501;
    shell = pkgs.fish;
  };

  system.primaryUser = username;
  users.knownUsers = [ username ];

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
}
