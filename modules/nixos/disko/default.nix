{
  flake,
  lib,
  ...
}:
with lib; let
  inherit (flake) inputs;
  cfg = config.desktop.modules.services.disko;
in {
  options.desktop.modules.services.disko = {
    enable = mkEnableOption "Enable disko";
    strategy = mkOption {
      type = types.str;
      default = "vm";
      description = "Partition strategy";
    };
    imports = [
      inputs.disko.nixosModules.disko
    ];
    config =
      mkIf cfg.enable {
      };
  };
}
