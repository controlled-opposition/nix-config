{ pkgs }:
{
  vim = {
    syntaxHighlighting = true;
    lsp = {
      enable = true;
      formatOnSave = true;
    };
    globals = {
      mapleader = " ";
    };
    autocomplete = {
      blink-cmp.enable = true;
    };
    languages = {
      nix = {
        enable = true;
        lsp.servers = [ "nixd" ];
        format.type = [ "nixfmt" ];
        extraDiagnostics.enable = true;
      };
    };
    treesitter = {
      enable = true;
      grammars = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
    };
    theme = {
      name = "oxocarbon";
      enable = true;
      style = "dark";
    };
    telescope.enable = true;
    binds.whichKey.enable = true;
    clipboard.enable = true;
    visuals = {
      rainbow-delimiters.enable = true;
    };
    filetree = {
      neo-tree = {
        enable = true;
        setupOpts.filesystem.filtered_items.hide_dotfiles = false;
      };
    };
  };
}
