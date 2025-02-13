{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
with lib; let
  cfg = config.desktop.modules.wm.sway;
  inherit (flake) inputs;
in {
  options.desktop.modules.wm.sway = {
    enable = mkEnableOption "Enable sway";
    isVirtualMachine = mkOption {
      type = types.bool;
      default = false;
      description = "Is build on VM";
    };
  };
  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        videoDrivers =
          if cfg.isVirtualMachine
          then ["virtualbox" "modesetting"]
          else ["nvidia"];
      };
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

    programs.sway = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
