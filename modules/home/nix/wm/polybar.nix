{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.homemodules.wm.modules.polybar;

  colors = {
    background = "#${cfg.colorScheme.palette.base00}";
    background-alt = "#${cfg.colorScheme.palette.base01}";

    foreground = "#${cfg.colorScheme.palette.base06}";

    primary = "#${cfg.colorScheme.palette.base0D}";
    secondary = "#${cfg.colorScheme.palette.base0C}";
    alert = "#${cfg.colorScheme.palette.base08}";
    disabled = "#${cfg.colorScheme.palette.base03}";
  };

  commonBarConfig = fonts: {
    monitor = "\${env:MONITOR}";
    enable-ipc = true;
    bottom = false;
    fixed-center = true;
    width = "100%";

    height = 34;
    background = "${colors.background}";
    foreground = "${colors.foreground}";
    radius = 0;
    line-size = 5;
    line-color = "${colors.foreground}";
    border-bottom-size = 0;

    border-bottom-color = "${colors.primary}";
    padding = 0;
    module-margin-left = 2;
    module-margin-right = 2;
    modules-right = "date";
  };
in
  with lib; {
    options.desktop.homemodules.wm.modules.polybar = {
      enable = mkEnableOption "Enable polybar";

      colorScheme = mkOption {
        type = types.attrs;
        description = "Color scheme used for polybar";
      };
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        d2coding
        unifont
        font-awesome
      ];

      services.polybar = {
        enable = true;

        package = pkgs.polybar.override {
          i3Support = true;
          githubSupport = true;
        };
        script = ''
          polybar main &
        '';

        config = let
          fonts = {
            font-0 = "D2Coding for Powerline:pixelsize=10;0";
            font-1 = "unifont:fontformat=truetype:size=10:antialias=false;0";
            font-2 = "Envy Code R:pixelsize=10;0";
            font-3 = "Font Awesome 5 Free:style=Regular:pixelsize=10;1";
            font-4 = "Font Awesome 5 Free:style=Solid:pixelsize=10;1";
            font-5 = "Font Awesome 5 Brands:pixelsize=10;1";
          };
        in
          mkMerge [
            # Common settings
            {
              "settings" = {
                screenchange-reload = "true";
                pseudo-transparency = true;
              };

              "global/wm" = {
                margin-top = 2;
                margin-bottom = 2;
              };

              "module/date" = {
                type = "internal/date";
                date = "%d/%m/%y %H:%M";
                label-mode-padding = 2;
              };
            }

            # i3 specific configuration
            (mkIf config.xsession.windowManager.i3.enable {
              "bar/main" =
                commonBarConfig fonts
                // {
                  wm-restack = "i3";
                  override-redirect = true;
                  modules-left = "i3";
                  scroll-up = "i3wm-wsnext";
                  scroll-down = "i3wm-wsprev";
                };

              "module/i3" = {
                type = "internal/i3";
                enable-click = true;
                enable-scroll = true;
                format = "<label-state> <label-mode>";
                index-sort = true;
                wrapping-scroll = false;
                pin-workspace = false;

                label-mode-padding = 2;
                label-mode-foreground = "${colors.foreground}";
                label-mode-background = "${colors.primary}";

                label-focused = "%index%";
                label-focused-background = "${colors.primary}";
                label-focused-padding = 2;

                label-unfocused = "%index%";
                label-unfocused-background = "${colors.background}";
                label-unfocused-padding = 2;

                label-visible = "%index%";
                label-visible-background = "${colors.secondary}";
                label-visible-padding = 2;

                label-urgent = "%index%";
                label-urgent-background = "${colors.alert}";
                label-urgent-padding = 2;
              };
            })

            # bspwm specific configuration
            (mkIf config.xsession.windowManager.bspwm.enable {
              "bar/main" =
                commonBarConfig fonts
                // {
                  wm-restack = "bspwm";
                  override-redirect = true;
                  modules-left = "bspwm";
                };

              "module/bspwm" = {
                type = "internal/bspwm";
                enable-click = true;
                enable-scroll = true;

                pin-workspaces = true;
                inline-mode = false;

                format = "<label-state> <label-mode>";

                label-focused = "%name%";
                label-focused-foreground = "${colors.background}";
                label-focused-background = "${colors.primary}";
                label-focused-padding = 2;

                label-occupied = "%name%";
                label-occupied-foreground = "${colors.foreground}";
                label-occupied-padding = 2;

                label-empty = "%name%";

                label-empty-foreground = "${colors.disabled}";
                label-empty-padding = 2;

                label-urgent = "%name%";
                label-urgent-foreground = "${colors.background}";
                label-urgent-background = "${colors.alert}";
                label-urgent-padding = 2;
              };
            })
          ];
      };
    };
  }
