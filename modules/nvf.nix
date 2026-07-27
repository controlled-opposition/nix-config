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
        };
        theme = {
          name = "everforest";
          enable = true;
          style = "medium";
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
        mini = {
          icons.enable = true;
          statusline.enable = true;
          pairs.enable = true;
        };
      };
    };
  };
}
