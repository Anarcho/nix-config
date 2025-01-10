{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.modules.notes.obsidian;
in {
  options.programs.modules.notes.obsidian = {
    enable = mkEnableOption "Enable obsidian";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
