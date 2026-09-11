{ inputs, pkgs, ... }:
{
  packages = builtins.attrValues {
    inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system})
      codex
      pi
      ;
  };
}
