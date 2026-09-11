{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };
  hjem.users.rick = {
    enable = true;
    imports = [
      ../../modules/language-tools
      ../../modules/nvf
      ../../modules/ai
    ];
    packages = builtins.attrValues {
      helium-flake = inputs."helium-flake".packages.${pkgs.stdenv.hostPlatform.system}.default;

      inherit (pkgs.kdePackages) dolphin;

      inherit (pkgs)
        emacs-unstable
        btop
        discord
        fastfetch
        fish
        git
        helix
        kitty
        obsidian
        spotify
        tmux
        vscode
        zed-editor
        zoxide
        gopeed
        faugus-launcher
        stow

        clang
        gnumake
        cmake
        libtool
        python3
        nodejs_latest
        direnv
        ;
    };
  };
}
