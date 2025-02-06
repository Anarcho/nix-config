{pkgs, ...}: {
  blink-cmp = {
    enable = true;
    settings = {
      appearance = {
        kind_icons = {
          Class = "󱡠";
          Color = "󰏘";
          Constant = "󰏿";
          Constructor = "󰒓";
          Copilot = "";
          Enum = "󰦨";

          EnumMember = "󰦨";
          Event = "󱐋";

          Field = "󰜢";
          File = "󰈔";
          Folder = "󰉋";
          Function = "󰊕";

          Interface = "󱡠";

          Keyword = "󰻾";
          Method = "󰊕";
          Module = "󰅩";
          Operator = "󰪚";
          Property = "󰖷";
          Reference = "󰬲";
          Snippet = "󱄽";
          Struct = "󱡠";
          Text = "󰉿";

          TypeParameter = "󰬛";
          Unit = "󰪚";
          Value = "󰦨";
          Variable = "󰆦";
        };
      };
      completion = {
        accept = {
          auto_brackets = {
            enabled = true;
          };
        };
        documentation = {
          auto_show = true;
        };
      };
      snippets = {
        preset = "luasnip";
        expand.__raw = ''
          function(snippet) require('luasnip').lsp_expand(snippet) end
        '';
        active.__raw = ''
          function(filter)
            if filter and filter.direction then

              return require('luasnip').jumpable(filter.direction)
            end
            return require('luasnip').in_snippet()
          end
        '';
        jump.__raw = ''
          function(direction) require('luasnip').jump(direction) end
        '';
      };

      keymap = {
        preset = "super-tab";
      };
      signature = {
        enabled = true;
      };
      sources = {
        cmdline = [];
        providers = {
          buffer = {
            score_offset = -7;
          };
          lsp = {
            fallbacks = [];
          };
        };
      };
    };
  };
  blink-compat = {
    enable = true;
  };
}
