{ ... }:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
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
          };
        };
        treesitter = {
          enable = true;
          fold = true;
        };
        statusline = {
          lualine.enable = true;
        };
        autopairs.nvim-autopairs.enable = true;
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };
        telescope.enable = true;
        utility.motion.precognition.enable = true;

      };
    };
  };
}
