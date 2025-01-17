{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.homemodules.wm.modules.rofi;

  colors = {
    base00 = "#${cfg.colorScheme.palette.base00}";
    base01 = "#${cfg.colorScheme.palette.base01}";
    base02 = "#${cfg.colorScheme.palette.base02}";
    base03 = "#${cfg.colorScheme.palette.base03}";
    base04 = "#${cfg.colorScheme.palette.base04}";
    base05 = "#${cfg.colorScheme.palette.base05}";
    base06 = "#${cfg.colorScheme.palette.base06}";
    base07 = "#${cfg.colorScheme.palette.base07}";
    base08 = "#${cfg.colorScheme.palette.base08}";
    base09 = "#${cfg.colorScheme.palette.base09}";
    base0A = "#${cfg.colorScheme.palette.base0A}";
    base0B = "#${cfg.colorScheme.palette.base0B}";
    base0C = "#${cfg.colorScheme.palette.base0C}";
    base0D = "#${cfg.colorScheme.palette.base0D}";
    base0E = "#${cfg.colorScheme.palette.base0E}";
    base0F = "#${cfg.colorScheme.palette.base0F}";
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
            background-color = mkLiteral colors.base00;
            foreground-color = mkLiteral colors.base07;
            text-color = mkLiteral colors.base07;
            border-color = mkLiteral colors.base04;
          };

          "#window" = {
            transparency = "real";
            background-color = mkLiteral colors.base00;
            text-color = mkLiteral colors.base07;
            border-color = mkLiteral colors.base04;
            border = mkLiteral "4px";
            border-radius = mkLiteral "4px";
            width = mkLiteral "850px";
            padding = mkLiteral "15px";
          };

          "#mainbox" = {
            background-color = mkLiteral colors.base00;
            border-color = mkLiteral colors.base04;
            border = mkLiteral "0px";
            border-radius = mkLiteral "0px";
            children = map mkLiteral [
              "inputbar"
              "message"
              "listview"
            ];
            spacing = mkLiteral "10px";
            padding = mkLiteral "10px";
          };

          "#text-box-colon" = {
            expand = false;
            str = ":";
            margin = mkLiteral "0px 0.3em 0em 0em";
            text-color = mkLiteral colors.base07;
          };

          "#prompt" = {
            enable = false;
          };

          "#entry" = {
            placeholder-color = mkLiteral colors.base03;
            expand = true;
            horizontal-align = "0";
            placeholder = "";
            padding = mkLiteral "0px 0px 0px 5px";
            blink = true;
          };

          "#inputbar" = {
            children = map mkLiteral [
              "prompt"
              "entry"
            ];
            border = mkLiteral "1px";
            border-radius = mkLiteral "4px";
            padding = mkLiteral "6px";
          };

          "#listview" = {
            background-color = mkLiteral colors.base00;
            padding = mkLiteral "0px";
            columns = 1;
            lines = 12;
            spacing = "5px";
            cycle = true;
            dynamic = true;
            layout = "vertical";
          };

          "#elemant" = {
            orientation = "vertical";
            border-radius = mkLiteral "0px";
            padding = mkLiteral "5px 0px 5px 5px";
          };

          "#element.selected" = {
            border = mkLiteral "1px";
            border-radius = mkLiteral "4px";
            border-color = mkLiteral colors.base07;
            background-color = mkLiteral colors.base05;
            text-color = mkLiteral colors.base00;
          };

          "#element-text" = {
            expand = true;
            vertical-align = mkLiteral "0.5";
            margin = mkLiteral "0px 2.5px 0px 2.5px";
          };

          "#element-text.selected" = {
            background-color = mkLiteral colors.base00;
          };

          "#element-icon" = {
            size = mkLiteral "18px";
            border = mkLiteral "0px";
            padding = mkLiteral "2px 5px 2px 2px";
          };

          "#element-icon.selected" = {
            background-color = mkLiteral colors.base04;
            text-color = mkLiteral colors.base00;
          };
        };
        xoffset = 0;
        yoffset = -20;

        extraConfig = {
          show-icons = true;
          kb-cancel = "Escape,Super+space";
          modi = "window,run,ssh";
          sort = true;
        };
      };
    };
  }
