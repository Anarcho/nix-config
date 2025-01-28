{
  bufferline = {
    enable = true;
    settings = {
      options = {
        mode = "buffers";

        numbers = "ordinal";
        diagnostics = "nvim_lsp";
        diagnostics_indicator = ''
          function(count, level)
            local icon = level:match("error") and " " or level:match("warning") and " " or ""
            return " " .. icon .. count
          end
        '';

        # Visual customization

        modified_icon = "●";
        buffer_close_icon = " 󰅙 ";

        close_icon = "󰅙";
        left_trunc_marker = "";
        right_trunc_marker = "";

        # Appearance
        separator_style = "thin";
        indicator.style = "icon";
        indicator.icon = "▎";

        # Buffer display settings
        max_name_length = 18;
        max_prefix_length = 15;
        tab_size = 18;

        # Features
        show_buffer_icons = true;
        show_buffer_close_icons = true;
        show_close_icon = true;

        show_tab_indicators = true;

        persist_buffer_sort = true;

        enforce_regular_tabs = false;
        always_show_bufferline = false;

        # Grouping configuration
        groups = {
          options = {
            toggle_hidden_on_enter = true;
          };
          items = [
            {
              name = "Tests";
              priority = 2;
              matcher.__raw = ''
                function(buf)
                  return buf.name:match('%_test') or buf.name:match('%_spec') or buf.name:match('test%.')
                end
              '';
            }
            {
              name = "Docs";
              priority = 3;
              matcher.__raw = ''
                function(buf)
                  return buf.name:match('%.md') or buf.name:match('%.txt') or buf.name:match('%.org')
                end

              '';
            }
            {
              name = "Config";
              priority = 4;

              matcher.__raw = ''
                function(buf)
                  return buf.name:match('%.json') or buf.name:match('%.yaml') or buf.name:match('%.toml')
                end
              '';
            }
          ];
        };
      };

      # Highlight configuration

      highlights = {
        buffer_selected = {
          bold = true;
          italic = false;
        };
        diagnostic_selected = {
          bold = true;

          italic = false;
        };
        info_selected = {
          bold = true;
          italic = false;
        };
        info_diagnostic_selected = {
          bold = true;
          italic = false;
        };
        warning_selected = {
          bold = true;
          italic = false;
        };
        warning_diagnostic_selected = {
          bold = true;
          italic = false;
        };
        error_selected = {
          bold = true;
          italic = false;
        };
        error_diagnostic_selected = {
          bold = true;
          italic = false;
        };
      };
    };
  };
}

