{ inputs, pkgs, ... }:
{
  packages = builtins.attrValues {
    inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system})
      codex
      pi
      ;

    autolith = inputs.autolith.packages.${pkgs.stdenv.hostPlatform.system}.autolith;
    hermes-agent = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}
