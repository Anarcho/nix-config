{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
with lib; let
  inherit (flake) inputs;
in {
  options.themes = {
    active = mkOption {
      type = types.str;
      description = "Active theme name";
    };
    colors = lib.mkOption {
      type = types.attrs;
      description = "Theme colors";
      internal = true;
    };
  };

  config = let
    themePath = ./schemes + "/${config.themes.active}";
  in {
    colors = import themePath;
    desktop.homemodules = {
      waybar.colorScheme = config.theme.colors;
      hyprland.colorScheme = config.theme.colors;
    };
  };
}
