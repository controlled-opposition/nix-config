{ inputs, pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system})
      hermes-agent
      claude-code
      ;

  };
}
