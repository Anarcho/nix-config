{
  flake,
  lib,
  ...
}: let
  inherit (flake) inputs;
in {
  imports = [
    inputs.disko.nixosModules.disko
  ];
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1G";
              type = "EF00"; # Fixed typo from "EFOO"
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults"];
              };
            };
            pv = {
              name = "pv";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "root_vg"; # Create the volume group your NixOS config uses
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                };
              };
            };
          };
        };
      };
    };
  };
}
