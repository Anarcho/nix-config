{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.modules.wm.bspwm;
in {
  options.desktop.modules.wm.bspwm = {
    enable = mkEnableOption "Enable bspwm Window Manager";
    isVirtualMachine = mkOption {
      type = types.bool;
      default = false;

      description = "Whether the host system is a virtual machine";
    };
    videoDrivers = lib.mkOption {
      type = types.listOf types.str;
      default = ["modesetting"];
      description = ''
        Possible values are:
        - Intel
        - nvidia
        - nouveau
        - amdgpu
        - radeon
        - vmware
        - virutalbox
        - modesetting
        - fbdev
        - vesa
      '';
    };
  };
  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        videoDrivers = ["nvidia"];

        # Window manager configuration
        windowManager.bspwm = {
          enable = true;
        };
        displayManager = {
          lightdm = {
            enable = true;
            greeters = {
              gtk = {
                theme = {
                  name = "gruvbox-dark-gtk";
                  package = pkgs.gruvbox-dark-gtk;
                };
              };
            };
          };
        };
      };
      displayManager.defaultSession = "none+bspwm";
    };

    environment.systemPackages = with pkgs; [
      xorg.libX11
      xorg.libXrandr
      xorg.libXinerama
      xorg.libXcursor
      xorg.libXi
    ];
  };
}
