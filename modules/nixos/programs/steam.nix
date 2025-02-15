{
  flake,
  lib,
  config,
  ...
}:
with lib; let
  inherit (flake) inputs;
  cfg = config.programs.modules.desktop.gaming.steam;
in {
  options.programs.modules.desktop.gaming.steam = {
    enable = mkEnableOption "Enable steam";
  };
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extest.enable = true;
    };
  };
}
