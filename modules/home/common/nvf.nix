{
  flake,
  pkgs,
  lib,
  config,
  ...
}: let
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
            };
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
                picker.enabled = true;
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
              zig = [
                "zls"
              ];
              nix = [
                "nils"
              ];
            };
          };
          binds = {
            whichKey = {
              enable = true;
              setupOpts = {
                preset = "helix";
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

            overseer = {
              package = overseer-nvim;
              setup = ''
                require("overseer").setup{
                  strategy = "toggleterm",
                  templates = { "builtin" },
                }
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
          ];
        };
      };
    };
  };
}
