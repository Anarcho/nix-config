{
  flake,
  pkgs,
  ...
}: {
  imports = [
    flake.inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        # Settings
        viAlias = false;
        vimAlias = true;

        # Globals
        globals.leaderKey = " ";

        # Options
        options.autoindent = true;
        searchCase = "smart";
        preventJunkFiles = true;
        lineNumberMode = "relNumber";

        # Theme
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        # LSP

        lsp = {
          formatOnSave = true;
          lspkind.enable = true;
          lspSignature.enable = true;
          lsplines.enable = true;
          lspconfig.enable = true;
        };

        languages = {
          # Nix
          nix = {
            enable = true;
            treesitter.enable = true;
            lsp.enable = true;
            lsp.server = "nil";
            format.enable = true;
            format.package = pkgs.alejandra;
          };

          rust.enable = true;
          zig.enable = true;
          python.enable = true;
          clang.enable = true;
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        autopairs.nvim-autopairs.enable = true;

        # Copilot
        assistant.copilot = {
          enable = true;
          cmp.enable = true;
        };

        dashboard = {
          dashboard-nvim = {
            enable = true;
            setupOpts = {
              theme = "doom";
              config = {
                center = [
                  {
                    icon = " ";
                    icon_hl = "Title";
                    desc = "Find File";
                    desc_hl = "String";
                    key = "f";
                    key_hl = "Number";
                    key_format = " %s";
                    action = "FzfLua files";
                  }
                ];
              };
            };
          };
        };

        visuals = {
          nvim-web-devicons.enable = true;
        };
        extraPlugins = with pkgs.vimPlugins; {
          fzf-lua = {
            package = fzf-lua;
            setup = "require('fzf-lua').setup{}";
            after = ["nvim-web-devicons"];
          };
        };
      };
    };
  };
}
