{
  flake,
  pkgs,
  lib,
  config,
  ...
}: let
  nix2Lua = flake.inputs.nvf.lib.nvim.lua.toLuaObject;
  inherit (flake.inputs.nvf.lib.nvim.dag) entryBetween entryAfter;
  inherit (lib.generators) mkLuaInline;
  setup = module: table: "require('${module}').setup(${nix2Lua table})";
  cfg = config.common.modules.editor.nvf;
in {
  imports = [
    flake.inputs.nvf.homeManagerModules.default
  ];
  options.common.modules.editor.nvf = {
    enable = lib.mkEnableOption "Enable NixVim configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          useSystemClipboard = true;
          options = {
            autoindent = true;
            smartindent = true;
            shiftwidth = 2;
            tabstop = 2;
          };

          globals.mapleader = " ";
          globals.localmapleader = " ";
          theme = {
            enable = true;
            name = "gruvbox";
            style = "dark";
          };

          luaConfigRC.basic = ''
              vim.api.nvim_create_autocmd('TextYankPost', {
                  desc = 'Highlight when yanking (copying) text',
                  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
                  callback = function()
                      vim.highlight.on_yank()
                  end
              })

            vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })
          '';

          luaConfigRC.diagnostic = ''
            vim.diagnostic.config({
              virtual_text = {
                spacing = 2,
              },
              signs = true,
              underline = true,
              update_in_insert = false,
              severity_sort = true,
            })
          '';

          statusline.lualine.enable = true;
          fzf-lua.enable = true;

          autocomplete.blink-cmp = {
            enable = true;
            setupOpts = {
              sources.default = [
                "lsp"
                "buffer"
                "path"
              ];
              signature = {
                enabled = true;
              };
            };
          };

          treesitter = {
            enable = true;
            addDefaultGrammars = true;
          };

          utility = {
            snacks-nvim = {
              enable = true;
              setupOpts = {
                dashboard = {
                  enabled = true;
                  sections = [
                    {
                      section = "header";
                    }
                    {
                      action = ":FzfLua files cwd_only=true hidden=false";
                      key = "f";
                      desc = "Find File";
                      icon = " ";
                      padding = 1;
                    }
                    {
                      action = ":FzfLua oldfiles cwd_only=true";
                      key = "r";
                      desc = "Recent Files";
                      icon = " ";
                      padding = 1;
                    }
                    {
                      action = ":FzfLua live_grep";
                      key = "g";
                      desc = "Find Text";
                      icon = " ";
                      padding = 1;
                    }
                    {
                      action = ":qa";
                      key = "q";
                      desc = "Quit";
                      icon = " ";
                      padding = 1;
                    }
                  ];
                };
                notifier.enabled = true;
                input.enabled = true;
              };
            };
          };

          lsp = {
            lspkind.enable = true;
            trouble.enable = true;
          };

          visuals = {
            nvim-web-devicons.enable = true;
          };

          tabline = {
            nvimBufferline = {
              enable = true;
              setupOpts = {
                options = {
                  style_preset = "minimal";
                  numbers = "none";
                };
              };
            };
          };

          languages = {
            enableLSP = true;
            enableTreesitter = true;
            enableFormat = true;
            nix.enable = true;
            zig.enable = true;
          };

          formatter.conform-nvim = {
            enable = true;
            setupOpts = {
              formatters_by_ft = {
                zig = [
                  "zls"
                ];
                nix = [
                  "nils"
                ];
                json = [
                  "jq"
                ];
              };
            };
          };

          comments.comment-nvim.enable = true;

          binds = {
            whichKey = {
              enable = true;
              setupOpts = {
                preset = "helix";
              };
              register = {
                "<leader>z" = "⚡ [Z]ig";
                "<leader>b" = "📑 [B]uffers";
                "<leader>f" = "🔍 [F]ind";
                "<leader>d" = "🚨 [D]iagnostics";
                "<leader>w" = "🪟 [W]indow";
                "<leader>o" = "🚀 [O]verseer";
                "<leader>l" = "💡 [L]SP";
                "<leader>g" = "🗯 [C]omment";
              };
            };
            cheatsheet.enable = true;
          };

          mini.surround.enable = true;
          autopairs.nvim-autopairs.enable = true;

          terminal.toggleterm = {
            enable = true;
            setupOpts = {
              direction = "float";
            };
          };

          extraPlugins = with pkgs.vimPlugins; {
            oil = {
              package = oil-nvim;
              setup = ''
                require("oil").setup{}
              '';
            };

            nvim-treesitter-textsubjects = {
              package = nvim-treesitter-textsubjects;
              setup = setup "nvim-treesitter.configs" {
                textsubjects = {
                  enable = true;
                  keymaps = {
                    "<cr>" = "textsubjects-smart";
                    ";" = "textsubjects-container-outer";
                    "i;" = "textsubjects-container-inner";
                  };
                };
              };
            };

            nvim-treesitter-textobjects = {
              package = nvim-treesitter-textobjects;
              setup = setup "nvim-treesitter.configs" {
                textobjects = {
                  select = {
                    enable = true;
                    lookahed = true;
                    keymaps = {
                      "af" = "@function.outer";
                      "if" = "@function.inner";
                      "ac" = "@class.outer";
                      "ic" = "@class.inner";
                    };
                    selection_modes = {
                      "@parameter.outer" = "v";
                      "@function.outer" = "V";
                      "@class.outer" = "V";
                    };
                  };
                  swap = {
                    enable = true;
                    swap_next = {
                      "cx;" = "@parameter.inner";
                    };
                    swap_previous = {
                      "cx," = "@parameter.inner";
                    };
                  };
                  move = {
                    enable = true;
                    set_jumps = true;
                    goto_next_start = {
                      "]f" = "@function.outer";
                      "]c" = "@class.outer";
                      "]s" = "@scope";
                    };
                    goto_previous_start = {
                      "[f" = "@function.outer";
                      "[c" = "@class.outer";
                      "[s" = "@scope";
                    };
                    goto_next_end = {
                      "]F" = "@function.outer";
                      "]C" = "@class.outer";
                    };
                    goto_previous_end = {
                      "[F" = "@function.outer";
                      "[C" = "@class.outer";
                    };
                  };
                };
              };
            };

            overseer = {
              package = overseer-nvim;
              setup = ''
                local overseer = require("overseer")
                overseer.setup({

                  strategy = {
                    "toggleterm",
                    direction = "float",
                  },
                  templates = { "builtin" },
                })

                -- Register user tasks

                overseer.register_template({
                  name = "Zig: build run",
                  builder = function()
                    return {
                      cmd = { "zig" },
                      args = { "build", "run" },
                      name = "zig build run",
                      cwd = vim.fn.getcwd(),
                      components = { "default" },
                    }
                  end,
                })

                overseer.register_template({
                  name = "Zig: build",
                  builder = function()
                    return {
                      cmd = { "zig" },
                      args = { "build" },
                      name = "zig build",
                      cwd = vim.fn.getcwd(),
                      components = { "default" },
                    }
                  end,
                })
              '';
            };
          };

          keymaps = [
            {
              mode = "n";
              key = "<C-t>";
              action = "<cmd>ToggleTerm<cr>";
              desc = "Toggle terminal";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>bd";
              action = "<cmd>bdelete<CR>";
              desc = "Close current buffer";
              silent = true;
            }
            {
              mode = "n";
              key = "<s-l>";
              action = "<cmd>BufferLineCycleNext<CR>";
              desc = "Next tab";
              silent = true;
            }
            {
              mode = "n";
              key = "<s-h>";
              action = "<cmd>BufferLineCyclePrev<CR>";
              desc = "Previous tab";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>bo";
              action = "<cmd>BufferLineCloseOthers<CR>";
              desc = "Close other buffers";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>bp";
              action = "<cmd>BufferLinePick<CR>";
              desc = "Pick buffer";
              silent = true;
            }
            {
              mode = "n";
              key = "<ESC>";
              action = ":nohlsearch<CR>";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader><leader>";

              action = "<cmd>FzfLua files<CR>";
              desc = "Find files";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>/";
              action = ":FzfLua grep_curbuf<CR>";
              desc = "Search in buffer";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>fg";
              action = ":FzfLua live_grep<CR>";
              desc = "Search in buffer";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>fr";
              action = ":FzfLua oldfiles cwd_only=true<CR>";
              desc = "Search in buffer";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>dl";
              action = ":FzfLua diagnostic_document<CR>";
              desc = "List diagnostic document";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>dw";
              action = ":FzfLua diagnostic_workspace<CR>";
              desc = "Workspace diagnostic";
              silent = true;
            }
            {
              mode = "n";
              key = "-";
              action = ":Oil<CR>";
              desc = "Open oil";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>oo";
              action = ":OverseerOpen[left]<CR>";
              desc = "Overseer open";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>or";
              action = ":OverseerRun<CR>";
              desc = "Overseer run";
              silent = true;
            }
            {
              mode = "n";

              key = "<leader>zr";
              action = ":OverseerRunCmd zig build run<CR>";

              desc = "Run zig build run";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>zb";
              action = ":OverseerRunCmd zig build<CR>";
              desc = "Run zig build";
              silent = true;
            }

            {
              mode = "n";
              key = "<leader>wv";
              action = ":vsplit<CR>";
              desc = "Split Vertical";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>wh";
              action = ":split<CR>";
              desc = "Split Horizontal";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>wq";
              action = ":q<CR>";
              desc = "Close Window";
              silent = true;
            }
            {
              mode = "n";
              key = "<C-h>";
              action = "<C-w>h";
              desc = "Move Left";
              silent = true;
            }
            {
              mode = "n";
              key = "<C-j>";
              action = "<C-w>j";
              desc = "Move Down";
              silent = true;
            }
            {
              mode = "n";
              key = "<C-k>";
              action = "<C-w>k";
              desc = "Move Up";
              silent = true;
            }
            {
              mode = "n";
              key = "<C-l>";
              action = "<C-w>l";
              desc = "Move Right";
              silent = true;
            }
            {
              mode = "n";
              key = "gd";
              action = "<cmd>lua vim.lsp.buf.definition()<CR>";
              desc = "Go to definition";
              silent = true;
            }
            {
              mode = "n";
              key = "gr";
              action = "<cmd>lua vim.lsp.buf.references()<CR>";
              desc = "References";
              silent = true;
            }
            {
              mode = "n";
              key = "gi";
              action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
              desc = "Implementation";
              silent = true;
            }
            {
              mode = "n";
              key = "K";
              action = "<cmd>lua vim.lsp.buf.hover()<CR>";
              desc = "Hover";
              silent = true;
            }
            {
              mode = "n";
              key = "<C-k>";
              action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
              desc = "Signature Help";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>rn";
              action = "<cmd>lua vim.lsp.buf.rename()<CR>";
              desc = "Rename symbol";
              silent = true;
            }
            {
              mode = "n";
              key = "<leader>ca";
              action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
              desc = "Code Action";
              silent = true;
            }
          ];
        };
      };
    };
  };
}
