{ pkgs, ... }: {
  programs.nvf = {
    enable = true;
    settings = {
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
          grammars = with pkgs.vimPlugins.nvim-treesitter; [withAllGrammars ];
        };
        theme = {
          name = "catppuccin";
          enable = true;
          style = "mocha";
        };
        telescope.enable = true;
        utility = {
          oil-nvim.enable = true;
        };
        binds.whichKey.enable = true;
        clipboard.enable = true;
        visuals = {
          rainbow-delimiters.enable = true;
        };
        filetree = {
          neo-tree.enable = true;
        };
      };
    };
  };
}
