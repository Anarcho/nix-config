{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  cfg = config.desktop.homemodules.wm;
in {
  options.desktop.homemodules.wm = {
    defaultTerminal = mkOption {
      type = types.addCheck types.str (
        terminal: let
          hasPkg = builtins.hasAttr terminal pkgs;
        in
          if hasPkg
          then true
          else throw "Terminal '${terminal}' is not a valid nix package."
      );
      default = "ghostty";
      description = "Default terminal to use with window manager";
    };
  };

  config = mkIf (osConfig.services.xserver.windowManager.i3.enable or false) {
    # Check terminal is installed
    assertions = [
      {
        assertion = any (p: p.pname or p.name == cfg.defaultTerminal) config.home.packages;
        message = "Terminal '${cfg.defaultTerminal}' not found in installed packages.";
      }
    ];

    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";

        keybindings = let
          modifier = "Mod4";
          terminal = cfg.defaultTerminal;
        in
          mkOptionDefault {
            # Open Applications
            "${modifier}+Return" = "exec ${pkgs.${terminal}}/bin/${terminal}";
            "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
            "${modifier}+q" = "kill";
            # Firefox - mod-f

            # Windows
            # - Close Window
            # - Move between windows - hjkl
            # - Move between windows - Alternative left, up, down, right

            # Open Windows:
            # - Vertical
            # - Horizontal

            # Floating/Tiled

            # Workspaces
            # - Open Workspaces
            # - Go to workspaces
            # - move window to workspaces
            # - Cycle workspaces - "ALT TAB"

            # Other Addtions:
            # - Lock screen, application search, bar, appearance (gaps)

            # Startup actions

            "${modifier}+l" = "exec ${pkgs.i3lock}/bin/i3lock";
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
      i3lock
    ];
  };
}
