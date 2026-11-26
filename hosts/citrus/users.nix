{ pkgs, ... }:
{
  users.users."rick" = {
    isNormalUser = true;
    description = "rick";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.bashInteractive;
  };

  programs.zsh.enable = true;

  programs.bash.enable = true;

  programs.flyline.enable = true;

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
