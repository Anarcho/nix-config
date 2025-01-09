{
  config,
  lib,
  pkgs,
  osConfig ? {},
  ...
}:
with lib; let
  cfg = config.desktop.homemodules.wm;
in {
  options.desktop.homemodules.wm = {
    defaultTerminal = mkOption {
      type = types.str;
      default = "ghostty";
      description = "Default Terminal to use with window manager";
      apply = terminal:
        assert lib.assertMsg (builtins.hasAttr terminal pkgs)
        "Terminal ${terminal} not found in pkg"; terminal;
    };
  };

  config = mkIf (osConfig.services.xserver.windowManager.i3.enable) {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";

        keybindings = let
          modifier = "Mod4";
          terminal = cfg.defaultTerminal;
        in
          mkOptionDefault {
            "${modifier}+Return" = "exec ${pkgs.${terminal}}/bin/${terminal}";
            "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
          };

        bars = [
          {
            position = "bottom";
            statusCommand = "${pkgs.i3status}/bin/i3status";
          }
        ];
      };
    };

    home.packages = with pkgs; [
      i3status
      rofi
    ];
  };
}
