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
          # Nix
          python = {
            enable = true;
            treesitter.enable = true;
            lsp.enable = true;
            lsp.server = "basedpyright";
            format.enable = true;
          };

          rust.enable = true;
          zig.enable = true;
          clang.enable = true;
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        autopairs.nvim-autopairs.enable = true;

        # Copilot
        assistant.copilot = {
          enable = true;
        };

        snippets = {
          luasnip = {
            enable = true;
            loaders = "require('luasnip.loaders.from_vscode').lazy_load()";
            providers = [
              "friendly-snippets"
            ];
          };
        };

        dashboard = {
          dashboard-nvim = {
            enable = true;
            setupOpts = {
              theme = "doom";
              config = {
                header = [
                  ""
                  ""
                  "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
                  "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
                  "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
                  "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
                  "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
                  "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
                  ""
                ];
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
                  {
                    icon = " ";
                    icon_hl = "Title";
                    desc = "Quit";
                    desc_hl = "String";
                    key = "q";
                    key_hl = "Number";
                    key_format = " %s";
                    action = "qa!";
                  }
                ];
              };
            };
          };
        };

        ui = {
          noice = {
            enable = true;
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

          # Blink
          blink-cmp = {
            package = blink-cmp;
            setup = "require('blink.cmp').setup{
                keymap = { preset = 'default'},

                appearance = {
                  use_nvim_cmp_as_default = true,
                };

                completion = {
                  accept = {
                    auto_brackets = {
                      enabled = true,
                    },
                  },

                  menu = {
                    draw = {
                      treesitter = {'lsp'},
                    },
                  },
                  documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                  },
                },
            }
            ";
            after = ["friendly-snippets"];
          };
        };
      };
    };
  };
}
