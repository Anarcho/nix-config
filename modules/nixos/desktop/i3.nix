{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.modules.wm.i3;
in {
  options.desktop.modules.wm.i3 = {
    enable = mkEnableOption "Enable i3 Window Manager";
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
        videoDrivers = "nvidia";

        # Window manager configuration
        windowManager.i3 = {
          enable = true;
          package = pkgs.i3-gaps;
        };
        displayManager = {
          lightdm = {
            enable = true;
            # TODO: Add more options here
          };
        };
      };
      displayManager.defaultSession = "none+i3";
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
