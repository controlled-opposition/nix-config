{ inputs, pkgs, ... }:
{
  programs.pi-coding-agent = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;
    extraPackages = [
      pkgs.bun
      pkgs.nodejs
    ];

    settings = {
      lastChangelogVersion = "0.87.1";
      theme = "dark";
      defaultProvider = "openai-codex";
      defaultModel = "gpt-6-luna";
      packages = [ "npm:pi-web-search" ];
      hideThinkingBlock = false;
      npmCommand = [ "bun" ];
    };
  };
}
