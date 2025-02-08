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
            enabled = false;
          };
        };

        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };

        ghost_text = {
          enabled = true;
        };
      };

      fuzzy = {
        prebuilt_binaries = {
          download = false;
          force_version = "v${pkgs.vimPlugins.blink-cmp.version}";
        };
      };

      snippets = {
        preset = "luasnip";
      };

      sources = {
        default = [
          "buffer"
          "lsp"
          "path"
          "snippets"
        ];

        providers = {
          lsp = {
            name = "LSP";
            module = "blink.cmp.sources.lsp";
            async = false;
            enabled = true;
            max_items = null;
            min_keyword_length = 0;
            override = null;
            score_offset = 0;
            should_show_items = true;
            timeout_ms = 2000;

            fallbacks = [
              "buffer"
            ];
          };
          path = {
            name = "Path";
            module = "blink.cmp.sources.path";
            score_offset = 3;
            fallbacks = [
              "buffer"
            ];
            opts = {
              label_trailing_slash = true;
              show_hidden_files_by_default = false;
              trailing_slash = false;
            };
          };
          buffer = {
            name = "Buffer";
            module = "blink.cmp.sources.buffer";
          };
        };
      };

      signature = {
        enabled = true;
      };
    };
  };
}
