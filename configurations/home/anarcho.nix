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
    wallpaperImage = "anime-city.jpg";
    defaultBrowser = "brave";
    # Bspwm enable options
    enablePolybar = false;
    enablePicom = false;
    enableRofi = true;
    #Hyprland enable options
    enableWaybar = true;
    enableSwaylock = true;
    enableFastfetch = true;
    colorScheme = "gruvbox-dark-medium";
  };

  common.modules.editor.nixvim.enable = true;
  home.username = "anarcho";
  home.homeDirectory = "/home/anarcho";
  systemd.user.startServices = "sd-switch";
  home.file = {
    ".config/assets" = {
      source = ../../assets;
      recursive = true;
    };
    ".config/assets/scripts/auto_start.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        # Wait for Hyprland to be fully started
        sleep 2

        # Kill any existing waybar instances
        pkill waybar || true

        # Start waybar in the background
        ${pkgs.waybar}/bin/waybar &

        # Wait for waybar to start
        while ! pgrep -x waybar >/dev/null; do
          sleep 0.1
        done
      '';
    };
  };
  home.persistence."/persist/home/anarcho" = {
    files = [
      ".config/tms/config.toml"
    ];
    allowOther = true;
  };

  home.stateVersion = "24.11";
}
