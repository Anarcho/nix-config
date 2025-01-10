{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  cfg = config.desktop.homemodules.wm;

  workspaces = {
    ws1 = "1:terminal";
    ws2 = "2:web";
    ws3 = "3:notes";
  };
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
    defaultBrowser = mkOption {
      type = types.addCheck types.str (
        browser: let
          hasPkg = builtins.hasAttr browser pkgs;
        in
          if hasPkg
          then true
          else throw "Browser '${browser}' is not a valid nix package."
      );
      default = "firefox";
      description = "Default browser to use with window manager";
    };
    defaultNotesApplication = mkOption {
      type = types.addCheck types.str (
        notes: let
          hasPkg = builtins.hasAttr notes pkgs;
        in
          if hasPkg
          then true
          else throw "Notes Applications '${notes}' is not a valid nix package."
      );
      default = "obsidian";
      description = "Default notes application to use with window manager";
    };

    wallpaperImage = mkOption {
      type = types.str;
      description = "Wallpaper name file";
    };
  };

  config = mkIf (osConfig.services.xserver.windowManager.i3.enable or false) {
    # Check terminal is installed
    assertions = [
      {
        assertion = any (p: p.pname or p.name == cfg.defaultTerminal) config.home.packages;
        message = "Terminal '${cfg.defaultTerminal}' not found in installed packages.";
      }
      {
        assertion = any (p: p.pname or p.name == cfg.defaultBrowser) config.home.packages;
        message = "Browser '${cfg.defaultBrowser}' not found in installed packages.";
      }
    ];

    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";

        keybindings = let
          modifier = "Mod4";
          terminal = cfg.defaultTerminal;
          browser = cfg.defaultBrowser;
          notes = cfg.defaultNotesApplication;
        in
          mkOptionDefault {
            "${modifier}+Return" = "exec ${pkgs.${terminal}}/bin/${terminal}";
            "${modifier}+f" = "exec ${pkgs.${browser}}/bin/${browser}";
            "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
            "${modifier}+q" = "kill";

            # Switch to workspaces
            "${modifier}+1" = "workspace ${workspaces.ws1}";
            "${modifier}+2" = "workspace ${workspaces.ws2}";
            "${modifier}+3" = "workspace ${workspaces.ws3}";

            # Modes
            "${modifier}+n" = "mode obsidian";

            #Workspace
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

        modes = {
          obsidian = {
            "p" = ''exec "xdg-open 'obsidian://open?vault=personal'"; mode "default"'';
            "Escape" = "mode default";
            "Return" = "mode default";
          };
        };

        assigns = {
          "${workspaces.ws1}" = [{class = "^${cfg.defaultTerminal}";}];
          "${workspaces.ws2}" = [{class = "^${cfg.defaultBrowser}";}];
          "${workspaces.ws3}" = [{class = "^${cfg.defaultNotesApplication}";}];
        };

        bars = [
          {
            position = "bottom";
            statusCommand = "${pkgs.i3status}/bin/i3status";
          }
        ];

        startup = [
          {
            command = "feh --bg-fill /home/anarcho/.config/assets/wallpapers/${cfg.wallpaperImage}";
            always = true;
          }
        ];
      };
    };

    home.packages = with pkgs; [
      i3status
      rofi
      feh
      i3lock
    ];
  };
}
