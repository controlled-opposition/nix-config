{ pkgs, ... }:
{
  users.users."rick" = {
    isNormalUser = true;
    description = "rick";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };
}
