{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nixVersions.latest;
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
