{ den, ... }:
{
  den.aspects.wsl.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        neovim
        wget
        claude-code
        texliveFull
        nixfmt
        fd
        fzf
        nh
        uv
      ];

      nixpkgs.config.allowUnfree = true;
      programs.nix-ld.enable = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      system.stateVersion = "25.11";
    };

  den.aspects.nixos.includes = [
    den._.define-user
    den._.primary-user
  ];
}
