{
  flake,
  lib,
  config,
  ...
}: {
  imports = [
    flake.inputs.impermanence.nixosModules.impermanence
  ];
  programs.fuse.userAllowOther = true;
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/log"
      "/var/lib/containers"
      "/var/lib/private"
      "/var/lib/NetworkManager"
    ];
  };
}
