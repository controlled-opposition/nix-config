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

    settings = {
      lastChangelogVersion = "0.87.1";
      theme = "dark";
      defaultProvider = "openai-codex";
      defaultModel = "gpt-6-luna";
      packages = [
        "npm:pi-web-access"
        "npm:@sting8k/pi-vcc"
        "npm:pi-mcp-adapter"
      ];
      hideThinkingBlock = false;
      npmCommand = [ "bun" ];
    };
  };

  home.file.".pi/agent/mcp.json".text = builtins.toJSON {
    mcpServers.nixos = {
      command = "uvx";
      args = [ "mcp-nixos" ];
      protocolVersion = "auto";
    };
  };
}
