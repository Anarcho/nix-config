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
        type = types.string;
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
        enable = true;
        settings = {
          reload = [cfg.wallPaper];
          wallpapers = [
            ",${cfg.wallPaper}"
          ];
        };
      };
    };
  }
