{ inputs, pkgs, ... }:
{
  programs.pi-coding-agent = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;
    extraPackages = [
      pkgs.bun
      pkgs.nodejs
      pkgs.uv
    ];

  };

}
