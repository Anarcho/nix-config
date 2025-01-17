{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.homemodules.wm.modules.picom;

  colors = {
    background = "#${cfg.colorScheme.palette.base00}";
    background-alt = "#${cfg.colorScheme.palette.base0B}";
    foreground = "#${cfg.colorScheme.palette.base07}";
    primary = "#${cfg.colorScheme.palette.base0A}";
    secondary = "#${cfg.colorScheme.palette.base09}";
    alert = "#${cfg.colorScheme.palette.base08}";
    disabled = "#${cfg.colorScheme.palette.base04}";
    borders = "#${cfg.colorScheme.palette.base0B}";

    other_1 = "#${cfg.colorScheme.palette.base0A}";
    other_2 = "#${cfg.colorScheme.palette.base0C}";
    other_3 = "#${cfg.colorScheme.palette.base0D}";
    other_4 = "#${cfg.colorScheme.palette.base0E}";
  };
in
  with lib; {
    options.desktop.homemodules.wm.modules.picom = {
      enable = mkEnableOption "Enable polybar";
    };

    config = mkIf cfg.enable {
      services.picom = {
        enable = true;
        activeOpacity = 0.8;
        inactiveOpacity = 0.8;
      };
    };
  }
