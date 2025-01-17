{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.homemodules.wm.modules.fastfetch;

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
    options.desktop.homemodules.wm.modules.fastfetch = {
      enable = mkEnableOption "Enable polybar";

      colorScheme = mkOption {
        type = types.attrs;
        description = "Color scheme used for fastfetch";
      };
    };

    config = mkIf cfg.enable {
      programs.fastfetch = {
        enable = true;
        settings = {
          logo = {
            source = "nixos_small";
            padding = {
              right = 1;
            };
          };
          display = {
            size = {
              binaryPrefix = "si";
            };
            color = "blue";
            separator = "  ";
          };
          modules = [
            {
              type = "datetime";
              key = "Date";
              format = "{1}-{3}-{11}";
            }
            {
              type = "datetime";
              key = "Time";
              format = "{14}:{17}:{20}";
            }
            "break"
            "player"
            "media"
          ];
        };
      };
    };
  }
