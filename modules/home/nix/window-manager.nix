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

  # Detect active window manager
  isBspwm = osConfig.services.xserver.windowManager.bspwm.enable or false;
  isHyprland = osConfig.programs.hyprland.enable or false;
  homeDir = config.home.homeDirectory;

  # Color scheme configuration
  colorScheme = inputs.nix-colors.colorSchemes.${cfg.colorScheme};
  colors = {
    background = "#${colorScheme.palette.base00}";
    foreground = "#${colorScheme.palette.base07}";
    primary = "#${colorScheme.palette.base0A}";
    secondary = "#${colorScheme.palette.base09}";
  };
  monitor = "HDMI-A-1";
  wallPaper = "~/.config/assets/wallpapers/${cfg.wallpaperImage}";

  # Helper function to validate package existence
  validatePackage = name: type:
    types.addCheck types.str (
      pkg: let
        hasPkg = builtins.hasAttr pkg pkgs;
      in
        if hasPkg
        then true
        else throw "${type} '${pkg}' is not a valid nix package."
    );
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./wm
  ];

  options.desktop.homemodules.wm = {
    defaultTerminal = mkOption {
      type = validatePackage "terminal" "Terminal";
      default = "ghostty";
      description = "Default terminal to use with window manager";
    };

    defaultBrowser = mkOption {
      type = validatePackage "browser" "Browser";
      default = "firefox";
      description = "Default browser to use with window manager";
    };

    wallpaperImage = mkOption {
      type = types.str;
      description = "Wallpaper image filename";
    };

    # BSPWM-specific options
    enablePolybar = mkOption {
      type = types.bool;
      default = false;
      description = "Enable polybar (BSPWM only)";
    };

    enablePicom = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Picom (BSPWM only)";
    };

    enableRofi = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Rofi";
    };

    enableFastfetch = mkOption {
      type = types.bool;
      default = false;
      description = "Enable fastfetch";
    };

    colorScheme = mkOption {
      type = types.str;
      default = "gruvbox-dark-medium";
      description = "Color scheme used for window manager";
    };

    # Hyprland-specific options
    enableWaybar = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Waybar (Hyprland only)";
    };

    enableSwaylock = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Swaylock (Hyprland only)";
    };
  };

  config = mkMerge [
    # Common configuration (applies to both WMs)
    (mkIf (isBspwm || isHyprland) {
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
    })

    # BSPWM-specific configuration
    (mkIf isBspwm {
      xsession.windowManager.bspwm = {
        enable = true;
        extraConfig = ''
          sleep 1

          ${optionalString cfg.enablePolybar "systemctl --user restart polybar"}

          sleep 2

          # Workspace setup
          bspc monitor -d 1 2 3 4 5

          # Window appearance
          bspc config top_padding         35
          bspc config bottom_padding      35

          bspc config border_width        1
          bspc config window_gap          8
          bspc config split_ratio         0.52

          # Behavior
          bspc config focus_follows_pointer true

          # Colors
          bspc config normal_border_color "${colors.foreground}"
          bspc config active_border_color "${colors.secondary}"
          bspc config focused_border_color "${colors.primary}"
        '';
      };

      services.sxhkd = {
        enable = true;
        keybindings = let
          terminal = "${pkgs.${cfg.defaultTerminal}}/bin/${cfg.defaultTerminal}";
          browser = "${pkgs.${cfg.defaultBrowser}}/bin/${cfg.defaultBrowser}";
        in {
          # Basic operations
          "super + Return" = terminal;
          "super + f" = browser;
          "super + d" = "${pkgs.rofi}/bin/rofi -show drun";
          "super + q" = "bspc node -c";
          "super + l" = "${pkgs.i3lock}/bin/i3lock";
          "super + p" = "${optionalString cfg.enablePolybar "${pkgs.polybar}/bin/polybar-msg cmd restart &"} ${pkgs.bspwm}/bin/bspc wm -r";

          # WM control
          "super + alt + {q,r}" = "bspc {quit,wm -r}";

          # Window management
          "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
          "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
          "super + space" = "bspc node -t '~floating'";

          # Workspace management
          "super + {1-5}" = "bspc desktop -f '{1-5}'";
          "super + shift + {1-5}" = "bspc node -d '{1-5}'";
        };
      };

      desktop.homemodules.wm.modules = mkIf isBspwm {
        polybar = mkIf cfg.enablePolybar {
          enable = true;
          colorScheme = colorScheme;
        };
        picom = mkIf cfg.enablePicom {
          enable = true;
        };
        rofi = mkIf cfg.enableRofi {
          enable = true;
          colorScheme = colorScheme;
          terminal = cfg.defaultTerminal;
        };
      };

      home.packages = with pkgs;
        [
          feh
          i3lock
          sxhkd
          xdo
          wmname
        ]
        ++ (optionals cfg.enablePolybar [polybar]);
    })

    # Hyprland Configuration
    (mkIf isHyprland {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          decoration = {
            rounding = 4;
            blur = {
              enabled = "yes";
              size = 2;
              passes = 3;
              special = "no";
            };
            dim_special = "0.0";
          };
          animations = {
            enabled = "true";
            bezier = [
              "overshot, 0.05, 0.9, 0.1, 1.05"
              "smooth, 0.5, 0, 0.99, 0.99"
              "snapback, 0.54, 0.42, 0.01, 1.34"
              "curve, 0.27, 0.7, 0.03, 0.99"
            ];
            animation = [
              "windows, 1, 5, overshot, slide"
              "windowsOut, 1, 5, snapback, slide"
              "windowsIn, 1, 5, snapback, slide"
              "windowsMove, 1, 5, snapback, slide"
              "border, 1, 5, default"
              "fade, 1, 5, default"
              "fadeDim, 1, 5, default"
              "workspaces, 1, 6, curve"
            ];
          };
          exec-once = [
            "${cfg.defaultTerminal}"
          ];
        };
        extraConfig = ''
          # Monitor configuration
          monitor=,preferred,auto,1

          # Set variables
          $terminal = ghostty
          $browser = brave
          $menu = wofi


          # Workspace 2
          windowrule=float,${cfg.defaultBrowser},workspace=2

          # Workspace 3
          workspace=3


          # Zen setup
          workspace = 1, persistent:true,monitor:HDMI-A-1,default:true
          windowrule=center,${cfg.defaultTerminal},workspace=1
          windowrulev2=float,class:^(${cfg.defaultBrowser}$),workspace=1
          windowrulev2=size 50% 100%,class:^(${cfg.defaultBrowser}$),workspace=1

          # Browser
          workspace = 2, persistent:true,monitor:HDMI-A-1
          windowrule=float,${cfg.defaultBrowser},workspace=2

          # Spotify
          workspace = 3, persistent:true,monitor:HDMI-A-1
          windowrule=float,^(Spotify)$,workspace=3

          workspace = 4, persistent:true,monitor:HDMI-A-1
          workspace = 5, persistent:true,monitor:HDMI-A-1

          # Keybinds
          bind = SUPER, Return, exec, $terminal
          bind = SUPER, F, exec, $browser
          bind = SUPER, D, exec, $menu
          bind = SUPER, Q, killactive,
          bind = SUPER, L, exec, swaylock
          bind = SUPER ALT, Q, exit,

          # Window management
          bind = SUPER, H, movefocus, l
          bind = SUPER, L, movefocus, r
          bind = SUPER, K, movefocus, u
          bind = SUPER, J, movefocus, d

          # Workspace management
          bind = SUPER, 1, workspace, 1
          bind = SUPER, 2, workspace, 2
          bind = SUPER, 3, workspace, 3
          bind = SUPER, 4, workspace, 4
          bind = SUPER, 5, workspace, 5

          bind = SUPER SHIFT, 1, movetoworkspace, 1
          bind = SUPER SHIFT, 2, movetoworkspace, 2
          bind = SUPER SHIFT, 3, movetoworkspace, 3
          bind = SUPER SHIFT, 4, movetoworkspace, 4
          bind = SUPER SHIFT, 5, movetoworkspace, 5

          # Window rules
          windowrule = float, ^(pavucontrol)$
        '';
      };
      desktop.homemodules.wm.modules.waybar = {
        enable = true;
      };

      services.hyprpaper = {
        enable = true;
        settings = {
          splash = "false";
          ipc = "on";
          preload = [
            "~/.config/assets/wallpapers/anime-city.jpg"
          ];
          wallpaper = [
            "HDMI-A-1,~/.config/assets/wallpapers/anime-city.jpg"
          ];
        };
      };
      home.packages = with pkgs; [
        wofi
        waybar
        swaylock
        wl-clipboard
      ];
    })
  ];
}
