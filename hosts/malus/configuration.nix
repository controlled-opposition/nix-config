{ pkgs, inputs, ... }:

{

  environment.systemPackages = builtins.attrValues {
    inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system})
      codex
      pi
      ;


    inherit (pkgs)
      gcc
      gnumake
      cmake
      nodejs_latest
      bun
      nixd
      nixfmt
      uv
      python3
      alejandra
      statix
      nh
      docker
      stow
      helix
      direnv
      ;
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

}
