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
  fileSystems."/persist".neededForBoot = true;

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
      {
        directory = "/home/anarcho/Repos";
        user = "anarcho";
        group = "users";
        mode = "0755";
      }
      {
        directory = "/home/anarcho/.config";
        user = "anarcho";
        group = "users";
        mode = "0700";
      }
      {
        directory = "/home/anarcho/.ssh";
        user = "anarcho";
        group = "users";
        mode = "0700";
      }
      {
        directory = "/home/anarcho/.local/share";
        user = "anarcho";
        group = "users";
        mode = "0755";
      }
      {
        directory = "/home/anarcho/.cache";
        user = "anarcho";
        group = "users";
        mode = "0700";
      }
    ];
    files = [
    ];
  };
}
