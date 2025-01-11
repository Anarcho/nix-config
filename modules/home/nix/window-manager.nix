{
  flake,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  inherit (flake) inputs;
  inherit (inputs) self;
  cfg = config.desktop.homemodules.wm;

  workspaces = {
    ws1 = "1:terminal";
    ws2 = "2:web";
    ws3 = "3:notes";
  };
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./wm
  ];

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

    wallpaperImage = mkOption {
      type = types.str;
      description = "Wallpaper name file";
    };

    enablePolybar = mkOption {
      type = types.bool;
      default = false;
      description = "Enable polybar";
    };

    colorScheme = mkOption {
      type = types.str;
      description = "Color scheme used for window manager";
      default = "gruvbox-dark-medium";
    };
  };

  config = mkMerge [
    (mkIf (osConfig.services.xserver.windowManager.i3.enable or false) {
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
          in
            mkOptionDefault {
              "${modifier}+Return" = "exec ${pkgs.${terminal}}/bin/${terminal}";
              "${modifier}+f" = "exec ${pkgs.${browser}}/bin/${browser}";
              "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
              "${modifier}+q" = "kill";

              "${modifier}+1" = "workspace ${workspaces.ws1}";
              "${modifier}+2" = "workspace ${workspaces.ws2}";
              "${modifier}+3" = "workspace ${workspaces.ws3}";

              "${modifier}+l" = "exec ${pkgs.i3lock}/bin/i3lock";
            };

          assigns = {
            "${workspaces.ws1}" = [{class = "^${cfg.defaultTerminal}";}];

            "${workspaces.ws2}" = [{class = "^${cfg.defaultBrowser}";}];
          };

          startup = [
            {
              command = "feh --bg-fill /home/anarcho/.config/assets/wallpapers/${cfg.wallpaperImage}";
              always = true;
            }
            {
              command = "systemctl --user restart polybar";
              always = true;
              notification = false;
            }
          ];
        };
      };

      desktop.homemodules.wm.modules.polybar = mkIf cfg.enablePolybar {
        enable = true;
        colorScheme = inputs.nix-colors.colorSchemes.${cfg.colorScheme};
      };

      home.packages = with pkgs; [
        rofi
        feh
        i3lock
      ];
    })

    (mkIf (osConfig.services.xserver.windowManager.bspwm.enable or false) {
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

      xsession.windowManager.bspwm = {
        enable = true;
        extraConfig = ''
          bspc monitor -d ${workspaces.ws1} ${workspaces.ws2} ${workspaces.ws3}

          # Window settings
          bspc config border_width         2
          bspc config window_gap          12
          bspc config split_ratio         0.52

          # Mouse behavior

          bspc config focus_follows_pointer true

          # Colors (using colorScheme later)
          bspc config normal_border_color "#444444"
          bspc config active_border_color "#666666"
          bspc config focused_border_color "#888888"

        '';
      };

      services.sxhkd = {
        enable = true;
        keybindings = {
          "super + Return" = "${pkgs.${cfg.defaultTerminal}}/bin/${cfg.defaultTerminal}";
          "super + f" = "${pkgs.${cfg.defaultBrowser}}/bin/${cfg.defaultBrowser}";
          "super + d" = "${pkgs.rofi}/bin/rofi -show drun";
          "super + alt + {q,r}" = "bspc {quit,wm -r}";

          "super + q" = "bspc node -c";
          "super + {1-3}" = "bspc desktop -f '{${workspaces.ws1},${workspaces.ws2},${workspaces.ws3}}'";
          "super + shift + {1-3}" = "bspc node -d '{${workspaces.ws1},${workspaces.ws2},${workspaces.ws3}}'";
          "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
          "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
          "super + space" = "bspc node -t '~floating'";
          "super + l" = "${pkgs.i3lock}/bin/i3lock";
        };
      };

      systemd.user.services = {
        wallpaper = {
          Unit = {
            Description = "Set wallpaper";
            After = ["graphical-session-pre.target"];
            PartOf = ["graphical-session.target"];
          };
          Install = {
            WantedBy = ["graphical-session.target"];
          };
          Service = {
            ExecStart = "${pkgs.feh}/bin/feh --bg-fill /home/anarcho/.config/assets/wallpapers/${cfg.wallpaperImage}";
            Type = "oneshot";
          };
        };
      };

      desktop.homemodules.wm.modules.polybar = mkIf cfg.enablePolybar {
        enable = true;
        colorScheme = inputs.nix-colors.colorSchemes.${cfg.colorScheme};
      };

      home.packages = with pkgs; [
        rofi
        feh
        i3lock
        sxhkd
        xdo
        wmname
      ];
    })
  ];
}
