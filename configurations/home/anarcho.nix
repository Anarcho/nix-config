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
  xdg.userDirs.createDirectories = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
    ];
  };

  common.modules.editor.nixvim.enable = true;
  home.username = "anarcho";
  home.homeDirectory = "/home/anarcho";
  home.file = {
    ".config/assets" = {
      source = ../../assets;
      recursive = true;
    };

    ".config/assets/scripts/auto_start.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        killall waybar
        pkill waybar
        sleep 0.1
        ${pkgs.waybar}/bin/waybar
      '';
    };
  };

  home.stateVersion = "24.11";
}
