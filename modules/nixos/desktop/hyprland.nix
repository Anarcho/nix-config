{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
with lib; let
  cfg = config.desktop.modules.wm.hyprland;
  inherit (flake) inputs;
in {
  options.desktop.modules.wm.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
  };
  config = mkIf cfg.enable {
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = false;
    };

    services = {
      xserver.videoDrivers = ["nvidia"];
      displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
          package = pkgs.kdePackages.sddm;
          theme = "sddm-astronaut-theme";
          extraPackages = with pkgs; [sddm-astronaut];
        };
      };
    };

    hardware.graphics.enable = true;

    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "*";
      config.hyprland.default = ["hyprland"];
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_CURRENT_DESKTOP = "Hyprland";
    };

    environment.systemPackages = with pkgs; [
      kitty
      wireplumber
      pipewire
      hyprland-qtutils
      hyprpaper
      sddm-astronaut
    ];
  };
}
