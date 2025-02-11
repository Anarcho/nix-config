{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = config.desktop.homemodules.wm;
  isBspwm = config.xsession.windowManager.bspwm.enable or false;
in {
  imports = [
    ./polybar.nix
    ./picom.nix
    ./rofi.nix
    ./fastfetch.nix
    ./hyprpaper.nix
    ./waybar.nix
  ];

  # Only define polybar service if we're using BSPWM
  config = lib.mkMerge [
    (lib.mkIf isBspwm {
      systemd.user.services.polybar = {
        Install.WantedBy = ["graphical-session.target"];
      };
    })
  ];
}
