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

  # Color scheme configuration
  colorScheme = inputs.nix-colors.colorSchemes.${cfg.colorScheme};
  colors = {
    background = "#${colorScheme.palette.base00}";
    foreground = "#${colorScheme.palette.base07}";
    primary = "#${colorScheme.palette.base0A}";
    secondary = "#${colorScheme.palette.base09}";
  };

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

      # Common wallpaper service
      systemd.user.services.wallpaper = {
        Unit = {
          Description = "Set wallpaper";
          After = ["graphical-session-pre.target"];
          PartOf = ["graphical-session.target"];
        };
        Install.WantedBy = ["graphical-session.target"];
        Service = {
          ExecStart =
            if isBspwm
            then "${pkgs.feh}/bin/feh --bg-fill /home/anarcho/.config/assets/wallpapers/${cfg.wallpaperImage}"
            else "${pkgs.hyprpaper}/bin/hyprpaper";
          Type = "oneshot";
        };
      };
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
        extraConfig = ''
          # Monitor configuration
          monitor=,preferred,auto,1

          # Set variables
          $terminal = ${pkgs.${cfg.defaultTerminal}}/bin/${cfg.defaultTerminal}
          $browser = ${pkgs.${cfg.defaultBrowser}}/bin/${cfg.defaultBrowser}
          $menu = ${pkgs.wofi}/bin/wofi --show drun

          # Keybinds
          bind = SUPER, Return, exec, $terminal
          bind = SUPER, F, exec, $browser
          bind = SUPER, D, exec, $menu
          bind = SUPER, Q, killactive,
          bind = SUPER, L, exec, ${pkgs.swaylock}/bin/swaylock
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

          # Colors
          general {
            col.active_border = ${colors.primary}
            col.inactive_border = ${colors.foreground}
          }

          exec-once = hyprpaper
        '';
      };
      desktop.homemodules.wm.modules.hyprpaper = {
        enable = true;
        monitor = "eDP-1";
        wallPaper = "/home/anarcho/.config/assets/wallpapers/${cfg.wallpaperImage}";
      };

      home.packages = with pkgs; [
        wofi
        swaylock
        wl-clipboard
        hyprpaper
      ];
    })
  ];
}
