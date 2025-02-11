{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.modules.wm.hyprland;
in {
  options.desktop.modules.wm.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };

    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
      };
    };

    services = {
      xserver.videoDrivers = ["nvidia"];
      displayManager = {
        sddm.enable = true;
        sddm.wayland.enable = true;
      };
    };

    hardware.graphics.enable = true;

    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    };

    environment.systemPackages = with pkgs; [
      kitty
      wireplumber
      pipewire
      xdg-desktop-portal
    ];

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
  };
}
