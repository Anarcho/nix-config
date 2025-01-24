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
        useSystemClipboard = true;
        spellcheck.enable = true;
        undoFile.enable = true;
        globals.defaultEditor = true;

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
          lsplines.enable = false;
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

        treesitter = {
          enable = true;
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        autopairs.nvim-autopairs.enable = true;
        binds.whichKey = {
          enable = true;
          setupOpts = {
            preset = "helix";
          };
        };

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
                    desc = "Recent Files";
                    desc_hl = "String";
                    key = "r";
                    key_hl = "Number";
                    key_format = " %s";
                    action = "FzfLua oldfiles";
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
          colorizer = {
            setupOpts.user_default_options = {
              AARRGGBB = true;
              RGB = true;
              RRGGBB = true;
            };
          };
        };

        tabline = {
          nvimBufferline = {
            enable = true;
            setupOpts.options.numbers = "none";
            mappings = {
              cycleNext = "<S-l>";
              cyclePrevious = "<S-h>";
              closeCurrent = "<leader>bd";
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

          img-clip = {
            package = img-clip-nvim;
            setup = ''
              require("img-clip").setup {
                default = {
                  embed_image_as_base64 = false,
                  prompt_for_file_name = false,
                  drag_and_drop = {
                    insert_mode = true,
                  },
                  use_absolute_path = true,
                },
              }
            '';
          };

          render-markdown = {
            package = render-markdown-nvim;
            setup = ''
              require("render-markdown").setup {
                file_types = { "markdown", "Avante" },
              }
            '';
          };

          blink-cmp = {
            package = blink-cmp;
            setup = ''
              require("blink.cmp").setup{
                keymap = { preset = "default" },
                appearance = {
                  use_nvim_cmp_as_default = true,
                },
                completion = {
                  accept = {
                    auto_brackets = {
                      enabled = true,
                    },
                  },
                  menu = {
                    draw = {
                      treesitter = { "lsp" },
                    },
                  },
                  documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                  },
                },
              }
            '';
            after = ["friendly-snippets"];
          };

          avante = {
            package = avante-nvim;
            setup = ''
              require("avante_lib").load()

              require("avante").setup{
                provider = "claude",
                auto_suggestions_provider = "claude",
                claude = {
                  endpoint = "https://api.anthropic.com",
                  model = "claude-3-5-sonnet-20241022",
                  max_tokens = 4096,
                },
                behaviour = {
                  auto_suggestions = false,
                  auto_set_highlight_group = true,
                  auto_set_keymaps = true,
                  auto_apply_diff_after_generation = false,
                  support_paste_from_clipboard = false,
                  minimize_diff = true,
                },
              }
            '';
            after = [
              "dressing-nvim"
              "plenary-nvim"
              "nui-nvim"
              "nvim-cmp"
              "nvim-web-devicons"
              "copilot-lua"
              "img-clip"
              "render-markdown"
            ];
          };
        };

        luaConfigPost = ''
            vim.opt.tabstop = 2
            vim.opt.shiftwidth = 2
            vim.opt.expandtab = true

            -- Highlight on Yank
            local augroup = vim.api.nvim_create_augroup
            local autocmd = vim.api.nvim_create_autocmd

            augroup('YankHighlight', { clear = true })
            autocmd('TextYankPost', {
              group = 'YankHighlight',
              callback = function()
                vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '100' })
              end
          })
        '';

        keymaps = [
          {
            key = "<leader><leader>";
            desc = "Find files";
            mode = "n";
            silent = true;
            action = ":FzfLua files<CR>";
          }
          {
            key = "<leader>/";
            desc = "Grep (Root Dir)";
            mode = "n";
            silent = true;
            action = ":FzfLua live_grep_native<CR>";
          }
          {
            key = "<leader>fb";
            desc = "Grep buffer";
            mode = "n";
            silent = true;
            action = ":FzfLua grep_curbuf<CR>";
          }
          {
            key = "<leader>gd";
            desc = "LSP Definitions";
            mode = "n";
            silent = true;
            action = ":FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<CR>";
          }
          {
            key = "<leader>gr";
            desc = "LSP References";
            mode = "n";
            silent = true;
            action = ":FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<CR>";
          }
          {
            key = "<leader>gI";
            desc = "LSP Implementations";
            mode = "n";
            silent = true;
            action = ":FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<CR>";
          }
          {
            key = "<leader>gy";
            desc = "LSP Type Defs";
            mode = "n";
            silent = true;
            action = ":FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<CR>";
          }
        ];
      };
    };
  };
}
