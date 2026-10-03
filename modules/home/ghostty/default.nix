{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" then pkgs.ghostty-bin else pkgs.ghostty;
  };
}
