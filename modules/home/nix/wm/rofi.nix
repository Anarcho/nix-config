{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.homemodules.wm.modules.rofi;

  colors = {
    background = "#1d2021";
    background2 = "#1f2223";
    background2-bottom = "#191c1d";
    background3 = "#303031";
    background3-bottom = "#272727";
    button = "#689d6a";
    button-bottom = "#518554";
    foreground = "#ebdbb2";
  };
in
  with lib; {
    options.desktop.homemodules.wm.modules.rofi = {
      enable = mkEnableOption "Enable polybar";
      colorScheme = mkOption {
        type = types.attrs;
        description = "Color scheme used for polybar";
      };
      terminal = mkOption {
        type = types.str;
        description = "Default terminal";
      };
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        jq
      ];
      programs.rofi = {
        enable = true;
        cycle = true;
        location = "center";
        font = "JetBrainsMono Nerd Font";
        pass = {};
        terminal = cfg.terminal;
        plugins = [
          pkgs.rofi-calc
          pkgs.rofi-emoji
          pkgs.rofi-systemd
        ];

        theme = let
          inherit (config.lib.formats.rasi) mkLiteral;
        in {
          "*" = {
            bg-col = mkLiteral colors.background;
            bg-col-transparent = mkLiteral "${colors.background}dd";
            bg-col-element = mkLiteral "${colors.background}df";
            bg-col-light = mkLiteral colors.button;
            border-col = mkLiteral colors.button;
            selected-col = mkLiteral colors.button;
            tab = mkLiteral colors.button;
            tab-selected = mkLiteral colors.background;
            fg-col = mkLiteral colors.foreground;
            fg-col2 = mkLiteral colors.background;
            blank = mkLiteral colors.background2;
            blank-underline = mkLiteral colors.background2-bottom;
            button = mkLiteral colors.button;
            button-underline = mkLiteral colors.button-bottom;
            window = mkLiteral colors.background3;
            window-underline = mkLiteral colors.background3-bottom;
            width = mkLiteral "600";
          };

          "#element-text" = {
            background-color = mkLiteral "#00000000";
            text-color = mkLiteral "inherit";
          };

          "#element-text.selected" = {
            background-color = mkLiteral "#00000000";
            text-color = mkLiteral "inherit";
          };

          "#mode-switcher" = {
            background-color = mkLiteral "#00000000";
          };

          "#window" = {
            height = mkLiteral "400px";
            width = mkLiteral "600px";
            border-radius = mkLiteral "10px";
            border = mkLiteral "0px 0px 8px 0px";
            border-color = mkLiteral "@window-underline";
            background-color = mkLiteral "@window";
            padding = mkLiteral "4px 8px 4px 8px";
            fullscreen = mkLiteral "false";
          };

          "#mainbox" = {
            background-color = mkLiteral "#00000000";
            padding = mkLiteral "2 2 2 2";
          };

          "#inputbar" = {
            children = map mkLiteral ["prompt" "entry"];
            background-color = mkLiteral "#00000000";
            border-radius = mkLiteral "5px";
            padding = mkLiteral "2px";
            margin = mkLiteral "0px -5px -4px -5px";
          };

          "#prompt" = {
            background-color = mkLiteral "@button";
            padding = mkLiteral "12px";
            text-color = mkLiteral "@bg-col";
            border-radius = mkLiteral "5px";
            margin = mkLiteral "8px 0px 0px 8px";
            border = mkLiteral "0px 0px 8px 0px";
            border-color = mkLiteral "@button-underline";
          };

          "#textbox-prompt-colon" = {
            expand = false;
            str = ":";
          };

          "#entry" = {
            padding = mkLiteral "12px 13px -4px 11px";
            margin = mkLiteral "8px 8px 0px 8px";
            text-color = mkLiteral "@fg-col";
            background-color = mkLiteral "@blank";
            border-radius = mkLiteral "5px";
            border = mkLiteral "0px 0px 8px 0px";
            border-color = mkLiteral "@blank-underline";
          };

          "#listview" = {
            border = mkLiteral "0px 0px 0px";
            margin = mkLiteral "27px 5px -13px 5px";
            background-color = mkLiteral "#00000000";
            columns = mkLiteral "1";
          };

          "#element" = {
            padding = mkLiteral "12px 12px 12px 12px";
            background-color = mkLiteral "@blank";
            text-color = mkLiteral "@fg-col";
            margin = mkLiteral "0px 0px 8px 0px";
            border-radius = mkLiteral "5px";
            border = mkLiteral "0px 0px 8px 0px";
            border-color = mkLiteral "@blank-underline";
          };

          "#element-icon" = {
            size = mkLiteral "25px";
            background-color = mkLiteral "#00000000";
          };

          "#element.selected" = {
            background-color = mkLiteral "@button";
            text-color = mkLiteral "@fg-col2";
            border-radius = mkLiteral "5px";
            border = mkLiteral "0px 0px 8px 0px";
            border-color = mkLiteral "@button-underline";
          };

          "#button" = {
            padding = mkLiteral "12px";
            margin = mkLiteral "10px 5px 10px 5px";
            background-color = mkLiteral "@blank";
            text-color = mkLiteral "@tab";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.5";
            border-radius = mkLiteral "5px";
            border = mkLiteral "0px 0px 8px 0px";
            border-color = mkLiteral "@blank-underline";
          };

          "#button.selected" = {
            background-color = mkLiteral "@bg-col-light";
            text-color = mkLiteral "@tab-selected";
            border-radius = mkLiteral "5px";
            border = mkLiteral "0px 0px 8px 0px";
            border-color = mkLiteral "@button-underline";
          };
        };

        extraConfig = {
          modi = "drun,run";
          sort = true;
          show-icons = true;
          kb-cancel = "Escape,Super+space";
          lines = 5;
          drun-display-format = "{icon} {name}";
          disable-history = true;
          hide-scrollbar = true;
          sidebar-mode = true;
          display-drun = " 󰀘  Apps ";
          display-run = "   Command ";
          display-window = "   Window ";
        };
      };
    };
  }
