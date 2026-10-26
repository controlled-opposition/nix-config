{ ... }:
{
  programs.nushell = {
    enable = true;
    loadSessionVariables = true;
  };
  programs.direnv.enableNushellIntegration = true;
  programs.mise.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
}
