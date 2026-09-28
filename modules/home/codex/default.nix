{ inputs, pkgs, ... }:
{
  programs.codex.enable = true;
  programs.codex.package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex;
}
