{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.homemodules.wm.modules.polybar;

  # Color definitions
  colors = {
    background = "#${cfg.colorScheme.palette.base00}";
    background-alt = "#${cfg.colorScheme.palette.base0B}";
    foreground = "#${cfg.colorScheme.palette.base07}";
    primary = "#${cfg.colorScheme.palette.base0A}";
    secondary = "#${cfg.colorScheme.palette.base09}";

    alert = "#${cfg.colorScheme.palette.base08}";
    disabled = "#${cfg.colorScheme.palette.base04}";
    borders = "#${cfg.colorScheme.palette.base0B}";
    other_1 = "#${cfg.colorScheme.palette.base0A}";
  };

  # Common configuration for all bars
  commonBarConfig = {
    monitor = "\${env:MONITOR}";
    enable-ipc = true;
    height = "22";
    bottom = false;
    fixed-center = true;
    radius = 10;
    background = "${colors.background}";
    foreground = "${colors.foreground}";
    dpi-x = 0;
    dpi-y = 0;
    dim-value = "1.0";
    line-size = 1;
    border-size = 2;
    border-color = "${colors.borders}";
    module-margin = 0;
    cursor-click = "pointer";
    cursor-scroll = "ns-resize";

    # Common font configuration
    font-0 = "JetBrainsMono Nerd Font:size=11:style=medium;2.5";
  };

  # Script definitions
  scripts = {
    local-ip = pkgs.writeScriptBin "polybar-local-ip" ''
      #!${pkgs.bash}/bin/bash
      local_interface=$(${pkgs.nettools}/bin/route | ${pkgs.gawk}/bin/awk '/^default/{print $NF}')
      local_ip=$(${pkgs.iproute2}/bin/ip addr show "$local_interface" | ${pkgs.gnugrep}/bin/grep -w "inet" | ${pkgs.gawk}/bin/awk '{ print $2; }' | ${pkgs.gnused}/bin/sed 's/\/.*$//')
      echo "# $local_ip"
    '';

    spotify = pkgs.writeScriptBin "polybar-spotify" ''
      #!${pkgs.bash}/bin/bash

      trim_title() {
        local title=$1
        local max_length=30

        if [ ''${#title} -gt $max_length ]; then
          title="''${title:0:$((max_length - 2))}.."
        fi
        echo "$title"
      }


      get_player_info() {
        local player=$1
        local status=$(${pkgs.playerctl}/bin/playerctl -p "$player" status 2> /dev/null)
        local title=$(${pkgs.playerctl}/bin/playerctl -p "$player" metadata title 2> /dev/null)

        echo "$status|$title"
      }


      prev_output=""
      while true; do
        players=$(${pkgs.playerctl}/bin/playerctl -l 2> /dev/null)

        active_player=""
        output=" 󰝚 "


        if [[ -n "$players" ]]; then
          for player in $players; do
            player_info=$(get_player_info "$player")
            status=$(echo "$player_info" | ${pkgs.coreutils}/bin/cut -d'|' -f1)
            title=$(echo "$player_info" | ${pkgs.coreutils}/bin/cut -d'|' -f2)


            if [[ "$status" == "Playing" ]]; then
              active_player="$player"
              output=$(trim_title "$title")
              break
            elif [[ "$status" == "Paused" && -z "$active_player" ]]; then
              active_player="$player"
              output=$(trim_title "$title")
            fi
          done

          if [[ -n "$active_player" ]]; then
            output="$([[ "$active_player" == "spotify" ]] && echo "󰓇" || echo "󰝚") $output"
          else
            output=" 󰎇 music 󰎇 "
          fi

        fi


        if [[ "$output" != "$prev_output" ]]; then
          echo "$output"
          prev_output="$output"
        fi

        ${pkgs.coreutils}/bin/sleep 1
      done
    '';
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
        pulseaudio
      ];

      services.polybar = {
        enable = true;
        package = pkgs.polybar.override {
          pulseSupport = true;
          githubSupport = true;
        };

        script = ''
          polybar ws &
          polybar title &
          polybar datetime &
          polybar system &

          polybar resources &
          polybar spotify &
        '';

        config = {
          "settings" = {
            screenchange-reload = true;
            pseudo-transparency = true;
          };

          # Bar configurations
          "bar/ws" =
            commonBarConfig
            // {
              wm-name = "bspwm";
              wm-restack = "bspwm";
              font-1 = "JetBrainsMono Nerd Font:style=Bold:size=15;2.5";
              font-2 = "JetBrainsMono Nerd Font:style=bold:size=21;5.3";
              bottom = true;
              width = "14%";
              offset-x = 4;
              offset-y = 4;
              modules-left = "pm cli nvim rfl ws";
            };

          "bar/title" =
            commonBarConfig
            // {
              wm-name = "bspwm";
              wm-restack = "bspwm";
              bottom = true;
              width = "11%";
              offset-x = "14.4%";
              offset-y = 4;

              modules-center = "title";
            };

          "bar/datetime" =
            commonBarConfig
            // {
              wm-name = "bspwm";
              wm-restack = "bspwm";
              width = "9%";

              offset-x = "45.5%";
              offset-y = 4;
              modules-center = "dt";
            };

          "bar/system" =
            commonBarConfig
            // {
              wm-name = "bspwm";
              wm-restack = "bspwm";
              width = "19%";
              offset-x = "81%";
              offset-y = 4;
              modules-center = "vol";
            };

          "bar/resources" =
            commonBarConfig
            // {
              wm-name = "bspwm";
              wm-restack = "bspwm";
              width = "15%";
              separator = "|";
              separator-foreground = "${colors.foreground}";
              separator-background = "${colors.background}";
              offset-x = 4;
              offset-y = 4;
              modules-center = "memory cpu";
            };

          "bar/spotify" =
            commonBarConfig
            // {
              wm-name = "bspwm";
              wm-restack = "bspwm";
              bottom = true;
              width = "19%";
              offset-x = "81%";
              offset-y = 4;
              modules-center = "spotify";
            };

          # Module configurations
          "module/ws" = {
            type = "internal/bspwm";
            pin-workspace = true;
            inline-mode = false;
            enable-click = true;
            enable-scroll = true;
            reverse-scroll = true;
            fuzzy-match = true;
            occupied-scroll = false;

            ws-icon-0 = "1;";
            ws-icon-1 = "2;";
            ws-icon-2 = "3;";
            ws-icon-3 = "4;";
            ws-icon-4 = "5;";

            format = "<label-state>";
            format-font = 2;
            format-padding = 0;

            label-focused = " ";
            label-focused-foreground = "${colors.background-alt}";
            label-focused-background = "${colors.background}";

            label-occupied = " ";
            label-occupied-foreground = "${colors.secondary}";

            label-urgent = " %icon%";
            label-urgent-foreground = "${colors.alert}";

            label-empty = " %icon%";
            label-empty-foreground = "${colors.foreground}";
          };

          "module/title" = {
            type = "internal/xwindow";
            format = "<label>";
            format-background = "${colors.background}";
            format-foreground = "${colors.foreground}";
            format-padding = 1;
            label = "%class%";
            label-empty = "󱕕 ";
            label-maxlen = 16;
          };

          "module/dt" = {
            type = "internal/date";
            interval = 1;
            date = " %I:%M %p";
            date-alt = " %a-%m-%d";
            label = "%date%";
            label-foreground = "${colors.foreground}";
            label-background = "${colors.background}";
          };

          "module/temperature" = {
            type = "internal/temperature";
            interval = 1;
            format = "<label>";
            zone-type = "x86_pkg_temp";
            label = "TEMP %temperature-c%";
            label-foreground = "${colors.foreground}";
            label-background = "${colors.background}";
          };

          "module/cpu" = {
            type = "internal/cpu";
            interval = 1;
            format = "<label>";
            format-padding = 1;
            label = "CPU %percentage%%";
          };

          "module/memory" = {
            type = "internal/memory";
            interval = 1;
            format-padding = 1;
            format = "RAM <label>";
            label = "%percentage_used%%";
            format-prefix-background = "${colors.background}";
          };

          "module/vol" = {
            type = "internal/pulseaudio";
            format-volume = "<ramp-volume><label-volume>";
            format-volume-foreground = "${colors.other_1}";
            format-volume-background = "${colors.background}";
            format-font = 1;
            mapped = true;
            use-ui-max = true;
            reverse-scroll = true;
            scroll-interval = 1;
            label-volume = "%percentage%%";
            label-volume-foreground = "${colors.other_1}";
            label-muted = " 󰖁 ";
            label-muted-foreground = "${colors.other_1}";
            label-muted-background = "${colors.background}";
            ramp-volume-0 = " ";
            ramp-volume-1 = " ";
            ramp-volume-2 = " ";
            ramp-volume-3 = " ";
            ramp-volume-4 = "  ";
            ramp-volume-5 = "  ";
            ramp-volume-6 = "  ";
            ramp-volume-7 = "  ";
            ramp-volume-8 = "  ";
            ramp-volume-9 = "  ";
            ramp-volume-foreground = "${colors.other_1}";
            ramp-headphones-0 = " ";
            ramp-headphones-1 = " ";
          };

          "module/spotify" = {
            type = "custom/script";
            exec = "${scripts.spotify}/bin/polybar-spotify";
            tail = true;
            format = "<label>";
            format-background = "${colors.background}";
            format-foreground = "${colors.foreground}";
            label = "%output%";
          };

          "module/local-ip" = {
            type = "custom/script";
            exec = "${scripts.local-ip}/bin/polybar-local-ip";
            interval = 60;
          };

          # Quick launch modules
          "module/pm" = {
            type = "custom/text";
            label = "󱄅";
            label-background = "${colors.background-alt}";
            label-foreground = "${colors.background}";
            label-padding = 1;
          };

          "module/nvim" = {
            type = "custom/text";
            label = "";
            label-background = "${colors.background-alt}";
            label-foreground = "${colors.background}";
            label-padding = 1;
          };

          "module/cli" = {
            type = "custom/text";
            label = "󰆍";
            label-background = "${colors.background-alt}";
            label-foreground = "${colors.background}";
            label-padding = 1;
          };

          "module/rfl" = {
            type = "custom/text";
            label = "";
            label-foreground = "${colors.background-alt}";
            label-font = 3;
          };
        };
      };
    };
  }
