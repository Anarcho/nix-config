{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.modules.music.spotify;
in {
  options.programs.modules.music.spotify = {
    enable = mkEnableOption "Enable spotify";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      spotifywm
    ];
  };
}
