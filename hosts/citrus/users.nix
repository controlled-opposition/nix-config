{ pkgs, ... }:
{
  users.users."rick" = {
    isNormalUser = true;
    description = "rick";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  users.users."rick".shell = pkgs.zsh;
}
