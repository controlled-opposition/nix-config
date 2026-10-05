{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment = {
    systemPackages = [
      pkgs.vim
      pkgs.micro
      pkgs.wget
    ];
    variables.EDITOR = "vim";
  };
}
