{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.homemodules.terminals.modules.ghostty;
in
  with lib; {
    options.desktop.homemodules.terminals.modules.ghostty = {
      enable = mkEnableOption "Enable polybar";
    };
    config = mkIf cfg.enable {
      programs.ghostty = {
        enable = true;
        settings = {
          theme = "GruvboxDarkHard";
          window-decoration = false;
          window-padding-y = 4;
          window-padding-x = 4;
          background-opacity = 0.8;
        };
        enableZshIntegration = true;
      };
    };
  }
