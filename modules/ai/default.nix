{ inputs, pkgs, ... }:
{
  packages = builtins.attrValues {
    inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system})
      codex
      pi
      hermes-agent
      claude-code
      ;

    autolith = inputs.autolith.packages.${pkgs.stdenv.hostPlatform.system}.autolith;
  };
}
