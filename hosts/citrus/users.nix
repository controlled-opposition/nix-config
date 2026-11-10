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

  security.sudo.enable = true;
  security.sudo.extraRules = [
    {
      users = [ "rick" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
