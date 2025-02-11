{
  flake,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.common
    self.homeModules.nix
    inputs.nix-colors.homeManagerModules.default
    inputs.impermanence.homeManagerModules.impermanence
  ];

  desktop.homemodules.wm = {
    defaultTerminal = "ghostty";
    wallpaperImage = "gruv-forest.png";
    defaultBrowser = "firefox";
    # Bspwm enable options
    enablePolybar = false;
    enablePicom = false;
    enableRofi = false;
    #Hyprland enable options
    enableWaybar = true;
    enableSwaylock = true;
    enableFastfetch = true;
    colorScheme = "gruvbox-dark-medium";
  };

  common.modules.editor.nixvim.enable = true;

  home.username = "anarcho";
  home.homeDirectory = "/home/anarcho";
  systemd.user.services.waybar = {
    Unit = {
      Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
      Documentation = "https://github.com/Alexays/Waybar/wiki";
      After = ["hyprland-session.target"];
      PartOf = ["hyprland-session.target"];
      Requires = ["hyprland-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      KillMode = "mixed";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "XDG_CURRENT_DESKTOP=Hyprland"
      ];
    };

    Install = {
      WantedBy = ["hyprland-session.target"];
    };
  };
  home.file = {
    ".config/assets" = {
      source = ../../assets;
      recursive = true;
    };

    ".config/assets/scripts/auto_start.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        hyprctl dispatch exec waybar
      '';
    };
  };

  home.stateVersion = "24.11";
}
