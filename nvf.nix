_: {
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
      };
      vim = {
        autocomplete = {
          blink-cmp.enable = true;
        };
        languages = {
          nix = {
            enable = true;
            lsp.servers = [ "nixd" ];
            format.type = [ "nixfmt" ];
            extraDiagnostics.enable = true;
            treesitter.enable = true;
          };
        };
        treesitter = {
          enable = true;
          textobjects.enable = true;
          context.enable = true;
        };
        statusline = {
          lualine.enable = true;
        };
        autopairs.nvim-autopairs.enable = true;
        theme = {
          enable = true;
          name = "rose-pine";
          style = "main";
        };
        telescope.enable = true;
        utility = {
          yazi-nvim.enable = true;
          surround.enable = true;
        };
        binds.whichKey.enable = true;
        clipboard.enable = true;
        visuals = {
          rainbow-delimiters.enable = true;
          nvim-web-devicons.enable = true;
        };
      };
    };
  };
}
