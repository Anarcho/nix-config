{
  flake,
  lib,
  config,
  pkgs,
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
    programs.gamescope.enable = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      gamescopeSession = {
        enable = true;
      };
    };
  };
}
