{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

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
