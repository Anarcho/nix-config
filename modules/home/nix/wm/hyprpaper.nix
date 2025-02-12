{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.homemodules.wm.modules.hyprpaper;
in
  with lib; {
    options.desktop.homemodules.wm.modules.hyprpaper = {
      enable = mkEnableOption "Enable hyprpaper";
      wallPaper = mkOption {
        type = types.str;
        description = "Path to wallpaper image";
      };
      monitor = mkOption {
        type = types.str;
        default = "eDP-1";
        description = "Monitor to set wallpaper for";
      };
    };
    config = mkIf cfg.enable {
      services.hyprpaper = {
        enable = false;
        settings = {
          ipc = "on";
          preload = [cfg.wallPaper];
          wallpaper = [
            "${cfg.monitor},${cfg.wallPaper}"
          ];
        };
      };
    };
  }
