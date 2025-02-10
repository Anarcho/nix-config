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
      xwayland.enable = true;
      withUWSM = false;
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

    environment.systemPackages = with pkgs; [
      kitty
    ];

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
  };
}
