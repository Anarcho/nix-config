{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.homemodules.wm.modules.waybar;
  colors = {
    #dark
    dark_red = "#cc241d";
    dark_green = "#98971a";
    dark_yellow = "#d79921";
    dark_blue = "#458588";
    dark_purple = "#b16286";
    dark_aqua = "#689d6a";
    dark_orange = "#d65d0e";

    # colors
    red = "#fb3934";
    green = "#b8bb26";
    yellow = "#fabd2f";
    blue = "#83a597";
    purple = "#d3869b";
    aqua = "#8ec07c";
    orange = "#fe8019";

    # BG
    bg = "#282828";
    bg0_h = "#1d2921";
    bg0_s = "#32302f";
    bg1 = "#3c3936";
    bg2 = "#504945";
    bg3 = "#665c54";
    bg4 = "#7c6f64";

    dark_gray = "#a89984";
    gray_light = "#928374";
    gray = "#928374";
    white = "#ffffff";

    # FG
    fg4 = "#a89984";
    fg3 = "#bdae93";
    fg2 = "#d5c4a1";
    fg1 = "#ebdbb2";
    fg0 = "#fbf1c7";

    # Other
    button-active = "#a5be7e";
    button-bottom = "#5d743e";
    button-hover = "#92ab6c";
    button = "#778f52";
    button-foreground = "#2d353b";
    foreground = "#d3c6aa";
    background-rgba = "rgba(35, 42, 46, 1)";

    mode = "#64727D";

    background-3 = "#343f44";
    background-3-bottom = "#2b3539";

    waybar-foreground = "#2d353b";

    #Other Power Menu
    powermenu-button = "#ee606a";
    powermenu-button-bottom = "#ca4853";

    waybar-clock = "#96a84c";
    waybar-clock-bottom = "#7a8c37";
  };
in
  with lib; {
    options.desktop.homemodules.wm.modules.waybar = {
      enable = mkEnableOption "Enable waybar";
      colorScheme = mkOption {
        type = types.attrs;
        description = "Color scheme used for waybar";
      };
    };

    config = mkIf cfg.enable {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = {
          mainBar = {
            layer = "top";
            height = 30;
            spacing = 4;
            modules-left = [
              "hyprland/workspaces"
              "hyprland/window"
            ];
            modules-right = [
              "cpu"
              "memory"
              "clock"
              "custom/powermenu"
            ];
            "custom/powermenu" = {
              format = "⏻ ";
              tooltip = false;
            };
            "clock" = {
              "tooltip-format" = "{:%H:%M}";
              "tootip" = true;
              "format-alt" = "{%A, %B %d %Y}";
              "format" = "{:%I:%M %p}";
            };
            "cpu" = {
              format = "{usage}% ";
              tooltip = false;
            };
            "memory" = {
              format = "{}% ";
            };
          };
        };
        style = ''
          * {
            font-family: JetBrainsMono Nerd Font, FontAwesome, Roboto, Helvetica, Arial, sans-serif;
            font-size: 14px;
            font-weight: bold;
          }

          window#waybar {
            background-color: ${colors.background-rgba};
            color: ${colors.foreground};
            transition-property: background-color;
            transition-duration: .5s;
          }

          window#waybar.hidden {
            opacity: 0.2;
          }

          window,workspaces {
            margin: 0 15px;
          }

          button {
            all: unset;
            background-color: ${colors.button};
            color: ${colors.button-foreground};
            font-family: JetBrainsMono Nerd Font, sans-serif;
            font-weight: bold;
            font-size: 14px;
            border: none;
            border-bottom: 8px solid ${colors.button-bottom};
            border-radius: 5px;
            margin-left: 6px;
            margin-top: 4px;
            margin-bottom: 4px;
            padding-left: 17px;
            padding-right: 17px;
            padding-top: 6px;
            padding-bottom: 6px;
            transition: transform 0.1s ease-in-out;
          }

          button:hover {
            background: inherit;
            background-color: ${colors.button-hover};
          }

          button.active {
            background: inherit;
            background-color: ${colors.button-active};
          }

          #mode {
            background-color: ${colors.mode};
            border-bottom: 3px solid ${colors.white};
          }


          #window {
            background-color: ${colors.background-3};
            color: ${colors.foreground};
            font-family: JetBrainsMono Nerd Font, monospace;
            font-weight: bold;
            font-size: 14px;
            border: none;
            border-bottom: 8px solid ${colors.background-3-bottom};
            border-radius: 5px;
            margin-top: 4px;
            margin-bottom: 4px;
            padding-left: 17px;
            padding-right: 17px;
          }

          #custom-powermenu {
            background-color: ${colors.powermenu-button};
            color: ${colors.waybar-foreground};
            font-family: JetBrainsMono, monospace;
            font-size: 22px;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            border-bottom: 8px solid ${colors.powermenu-button-bottom};
            margin-top: 4px;
            margin-bottom: 4px;
            margin-right: 6px;
            padding-left: 14px;
            padding-right: 7px;
          }

          #clock {
            background-color: ${colors.green};
            color: ${colors.waybar-foreground};
            font-family: JetBrainsMono, monospace;
            font-size: 14px;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            border-bottom: 8px solid ${colors.dark_green};
            margin-top: 4px;
            margin-bottom: 4px;
            padding-left: 7px;
            padding-right: 7px;
          }

          #memory {
            background-color: ${colors.purple};
            color: ${colors.waybar-foreground};
            font-family: JetBrainsMono, monospace;
            font-size: 14px;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            border-bottom: 8px solid ${colors.dark_purple};
            margin-top: 4px;
            margin-bottom: 4px;
            padding-left: 14px;
            padding-right: 14px;
          }
          #cpu {
            background-color: ${colors.yellow};
            color: ${colors.waybar-foreground};
            font-family: JetBrainsMono, monospace;
            font-size: 14px;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            border-bottom: 8px solid ${colors.dark_yellow};
            margin-top: 4px;
            margin-bottom: 4px;
            padding-left: 14px;
            padding-right: 14px;
          }
        '';
      };
    };
  }
