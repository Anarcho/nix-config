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

  # Workspace definitions
  workspaces = {
    ws1 = "1";
    ws2 = "2";
    ws3 = "3";
    ws4 = "4";
    ws5 = "5";
  };

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

    enablePolybar = mkOption {
      type = types.bool;
      default = false;
      description = "Enable polybar";
    };

    enablePicom = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Picom";
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
  };

  config = mkIf (osConfig.services.xserver.windowManager.bspwm.enable or false) {
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

    # BSPWM configuration
    xsession.windowManager.bspwm = {
      enable = true;
      extraConfig = ''
        # Workspace setup
        bspc monitor -d ${concatStringsSep " " (attrValues workspaces)}

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

    # Keybinding configuration
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
        "super + p" = "${pkgs.polybar}/bin/polybar-msg cmd restart & ${pkgs.bspwm}/bin/bspc wm -r";

        # WM control
        "super + alt + {q,r}" = "bspc {quit,wm -r}";

        # Window management
        "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
        "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
        "super + space" = "bspc node -t '~floating'";

        # Workspace management
        "super + 1" = "bspc desktop -f '${workspaces.ws1}'";
        "super + 2" = "bspc desktop -f '${workspaces.ws2}'";
        "super + 3" = "bspc desktop -f '${workspaces.ws3}'";
        "super + 4" = "bspc desktop -f '${workspaces.ws4}'";
        "super + 5" = "bspc desktop -f '${workspaces.ws5}'";

        "super + shift + 1" = "bspc node -d '${workspaces.ws1}'";
        "super + shift + 2" = "bspc node -d '${workspaces.ws2}'";
        "super + shift + 3" = "bspc node -d '${workspaces.ws3}'";
        "super + shift + 4" = "bspc node -d '${workspaces.ws4}'";
        "super + shift + 5" = "bspc node -d '${workspaces.ws5}'";
      };
    };

    # Wallpaper service
    systemd.user.services.wallpaper = {
      Unit = {
        Description = "Set wallpaper";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        ExecStart = "${pkgs.feh}/bin/feh --bg-fill /home/anarcho/.config/assets/wallpapers/${cfg.wallpaperImage}";
        Type = "oneshot";
      };
    };

    # Module configurations
    desktop.homemodules.wm.modules = {
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
      fastfetch = mkIf cfg.enableFastfetch {
        enable = true;
        colorScheme = colorScheme;
      };
    };

    # Required packages
    home.packages = with pkgs; [
      feh
      i3lock
      sxhkd
      xdo
      wmname
    ];
  };
}
