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
      pkgs.yq-go
      pkgs.jq
      pkgs.ripgrep
      pkgs.fd
      pkgs.ast-grep
      pkgs.curl
      pkgs.hyperfine
    ];
    variables.EDITOR = "vim";
  };
}
