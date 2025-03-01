{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (flake) inputs;
  inherit (inputs) self;
  cfg = config.desktop.homemodules.themes;
in {
  options.desktop.homemodules.themes = {
    enable = mkEnableOption "desktop theme configuration";
    cursorTheme = mkOption {
      type = types.str;
      default = "Bibata-Modern-Ice";
      description = "Name of the cursor theme to use";
    };

    cursorPackage = mkOption {
      type = types.package;
      default = pkgs.bibata-cursors;
      description = "Package providing the cursor theme";
    };

    gtkTheme = mkOption {
      type = types.str;
      default = "adw-gtk3";
      description = "Name of the GTK theme to use";
    };

    gtkPackage = mkOption {
      type = types.package;
      default = pkgs.adw-gtk3;
      description = "Package providing the GTK theme";
    };
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      cursorTheme = {
        package = cfg.cursorPackage;
        name = cfg.cursorTheme;
      };
      theme = {
        package = cfg.gtkPackage;
        name = cfg.gtkTheme;
      };
    };

    qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        name = "adwaita";
      };
    };
  };
}
