{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.modules.languages.languages;
in {
  options.programs.modules.languages.languages = {
    enable = mkEnableOption "Programming Languages install";
  };

  # need to fix to make selectable
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs_18 # used for copilot
      stdenv.cc.cc.lib
    ];
  };
}
