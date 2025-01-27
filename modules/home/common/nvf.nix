{
  flake,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.common.modules.editor.nvf;
in {
  imports = [
    flake.inputs.nvf.homeManagerModules.default
  ];
  options.common.modules.editor.nvf = {
    enable = mkEnableOption "Enable NVF configuration";
  };
  config = mkIf cfg.enable {
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
            lspSignature.enable = true;
            lspkind.enable = true;
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

            zig = {
              enable = true;
              treesitter.enable = true;
              lsp.enable = true;
              lsp.server = "zls";
            };
            clang.enable = true;
          };

          treesitter = {
            enable = true;
          };

          statusline.lualine.enable = true;
          telescope.enable = true;
          autocomplete.nvim-cmp = {
            enable = true;
          };
          autopairs.nvim-autopairs = {
            enable = true;
            setupOpts = {
              check_ts = true;
            };
          };

          binds = {
            whichKey = {
              enable = true;
              setupOpts = {
                preset = "helix";
              };
            };
            cheatsheet = {
              enable = true;
            };
          };

          # Copilot
          assistant.copilot = {
            enable = true;
            cmp.enable = true;
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
                      desc = "Recent Project Files";
                      desc_hl = "String";
                      key = "r";
                      key_hl = "Number";
                      key_format = " %s";
                      action = "FzfLua oldfiles cwd_only=true";
                    }
                    {
                      icon = " ";
                      icon_hl = "Title";
                      desc = "Recent Files";
                      desc_hl = "String";
                      key = "R";
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

          # terminal
          terminal = {
            toggleterm = {
              enable = true;
              lazygit = {
                enable = true;
                mappings = {
                  open = "<leader>gg";
                };
              };
              setupOpts = {
                direction = "horizontal";
              };
              mappings = {
                open = "<leader>tt";
              };
            };
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

            conform = {
              package = conform-nvim;
              setup = ''
                require("conform").setup{
                  formatters_by_ft = {
                    zig = {"zigfmt", lsp_format = "fallback"},
                  };

                  default_format_opts = {
                    lsp_format = "fallback",
                  },

                  format_on_save = {
                    lsp_format = "fallback",
                    timeout_ms = 500,
                  },

                  format_after_save = {
                    lsp_format = "fallback",
                  },
                }
              '';
              after = ["neotest-zig" "plenary-nvim" "nviom-treesitter" "FixCursorHold-nvim"];
            };

            neotest-zig = {
              package = neotest-zig;
            };
            neotest = {
              package = neotest;
              setup = ''
                require('neotest').setup{
                  adapters = {
                    require('neotest-zig')({
                      dap = {
                        adapter = "lldb";
                      }
                    }),
                  }
                }
              '';
            };
            overseer = {
              package = overseer-nvim;
              setup = ''
                require('overseer').setup{
                  cmd = {
                    "OverseerOpen",
                    "OverseerClose",
                    "OverseerToggle",
                    "OverseerSaveBundle",
                    "OverseerLoadBundle",
                    "OverseerDeleteBundle",
                    "OverseerRunCmd",
                    "OverseerRun",
                    "OverseerInfo",
                    "OverseerBuild",
                    "OverseerQuickAction",
                    "OverseerTaskAction",
                    "OverseerClearCache",
                  },
                }
              '';
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
            # File Finding
            {
              key = "<leader><leader>";
              desc = "Find files";
              mode = "n";
              silent = true;

              action = ":FzfLua files<CR>";
            }
            # Search
            {
              key = "<leader>/";
              desc = "Search in buffer";
              mode = "n";
              silent = true;
              action = ":FzfLua grep_curbuf<CR>";
            }
            {
              key = "<C-k>";
              desc = "Hover";
              mode = "n";
              silent = true;
              action = ":lua vim.diagnostic.open_float()<CR>";
            }
            {
              key = "<leader>dl";
              desc = "List Diagnostics";
              mode = "n";

              silent = true;
              action = ":FzfLua diagnostics_document<CR>";
            }
            {
              key = "<leader>dw";
              desc = "Workspace Diagnostics";
              mode = "n";
              silent = true;
              action = ":FzfLua diagnostics_workspace<CR>";
            }
            {
              key = "[d";
              desc = "Previous Diagnostic";
              mode = "n";
              silent = true;
              action = ":lua vim.diagnostic.goto_prev()<CR>";
            }
            {
              key = "]d";
              desc = "Next Diagnostic";
              mode = "n";
              silent = true;
              action = ":lua vim.diagnostic.goto_next()<CR>";
            }
            # Buffer Management
            {
              key = "<leader>b";
              desc = "+Buffer";
              mode = "n";
              action = "nop";
            }
            {
              key = "<leader>bd";
              desc = "Delete Buffer";

              mode = "n";
              silent = true;
              action = ":bd<CR>";
            }
            {
              key = "<leader>bn";
              desc = "Next Buffer";
              mode = "n";
              silent = true;
              action = ":bnext<CR>";
            }
            {
              key = "<leader>bp";
              desc = "Previous Buffer";
              mode = "n";
              silent = true;
              action = ":bprevious<CR>";
            }
            # Window Management
            {
              key = "<leader>ww";
              desc = "+Window";
              mode = "n";
              action = "nop";
            }
            {
              key = "<leader>wv";
              desc = "Split Vertical";
              mode = "n";
              silent = true;
              action = ":vsplit<CR>";
            }
            {
              key = "<leader>wh";
              desc = "Split Horizontal";

              mode = "n";
              silent = true;
              action = ":split<CR>";
            }
            {
              key = "<leader>wq";
              desc = "Close Window";
              mode = "n";
              silent = true;
              action = ":q<CR>";
            }
            {
              key = "<C-h>";
              desc = "Move Left";
              mode = "n";
              silent = true;
              action = "<C-w>h";
            }
            {
              key = "<C-j>";

              desc = "Move Down";
              mode = "n";
              silent = true;
              action = "<C-w>j";
            }
            {
              key = "<C-k>";
              desc = "Move Up";
              mode = "n";
              silent = true;
              action = "<C-w>k";
            }
            {
              key = "<C-l>";

              desc = "Move Right";
              mode = "n";
              silent = true;

              action = "<C-w>l";
            }
            # Quick Actions
            {
              key = "<leader>qq";

              desc = "Quit";
              mode = "n";
              silent = true;
              action = ":qa<CR>";
            }
            {
              key = "<leader>s";
              desc = "Save";
              mode = "n";
              silent = true;
              action = ":w<CR>";
            }
            # Copilot
            {
              key = "<leader>c";
              desc = "+Copilot";
              mode = "n";
              action = "nop";
            }
            {
              key = "<leader>ce";
              desc = "Enable Copilot";
              mode = "n";
              silent = true;
              action = ":Copilot enable<CR>";
            }
            {
              key = "<leader>cd";
              desc = "Disable Copilot";
              mode = "n";
              silent = true;
              action = ":Copilot disable<CR>";
            }
            {
              key = "<leader>cp";
              desc = "Open Copilot panel";
              mode = "n";
              silent = true;
              action = ":CopilotPanel<CR>";
            }
            # Terminal
            {
              key = "<leader>t";
              desc = "+Terminal";
              mode = "n";
              action = "nop";
            }
            {
              key = "<leader>tt";
              desc = "Toggle Terminal";
              mode = "n";
              silent = true;
              action = ":ToggleTerm<CR>";
            }
            # Git
            {
              key = "<leader>g";
              desc = "+Git";
              mode = "n";
              action = "nop";
            }
            {
              key = "<leader>gs";
              desc = "Status";
              mode = "n";
              silent = true;
              action = ":FzfLua git_status<CR>";
            }
            {
              key = "<leader>gb";
              desc = "Branches";
              mode = "n";
              silent = true;
              action = ":FzfLua git_branches<CR>";
            }
            # Code runner
            {
              key = "<leader>ow";
              desc = "Task list";
              mode = "n";
              silent = true;
              action = ":OverseerToggle<CR>";
            }
            {
              key = "<leader>o";
              desc = "+Overseer";
              mode = "n";
              silent = true;
              action = "nop";
            }
            {
              key = "<leader>oo";
              desc = "Run task";
              mode = "n";
              silent = true;
              action = ":OverseerRun<CR>";
            }
            {
              key = "<leader>oo";
              desc = "Run task";
              mode = "n";
              silent = true;
              action = ":OverseerRun<CR>";
            }
            # Misc
            {
              key = "<ESC>";
              desc = "Clear highlighting";
              mode = "n";
              silent = true;
              action = ":nohlsearch<CR>";
            }
            {
              key = "<leader>R";
              desc = "Lsp restart";
              mode = "n";
              silent = true;
              action = ":LspRestart<CR>";
            }
          ];
        };
      };
    };
  };
}
