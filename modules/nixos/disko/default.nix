{
  flake,
  lib,
  config,
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
  };
  imports = [
    inputs.disko.nixosModules.disko
  ];

  config = mkMerge [
    (mkIf (cfg.strategy == "vm") {
      disko.devices = {
        disk = {
          main = {
            device = "/dev/sda";
            type = "disk";
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  type = "EF00";
                  size = "500M";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = ["umask=0077"];
                  };
                };
                root = {
                  size = "100%";
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/";
                  };
                };
              };
            };
          };
        };
      };
    })
    (mkIf (cfg.strategy == "impermanance") {
      disko.devices = {};
    })
  ];
}
