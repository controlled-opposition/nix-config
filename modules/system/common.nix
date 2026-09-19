{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment = {
    systemPackages = [
      pkgs.vim
      pkgs.wget
    ];
    variables.EDITOR = "vim";
  };
}
