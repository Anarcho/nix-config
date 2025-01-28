{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.nameservers = ["8.8.8.8" "1.1.1.1" "8.8.4.4"];

  time.timeZone = "Australia/Brisbane";

  nixpkgs.hostPlatform = "x86_64-linux";

  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";

    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=2G" "mode=755"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/D0BC-A865";
      fsType = "vfat";
      options = ["defaults"];
      neededForBoot = true;
    };

    "/nix" = {
      device = "/dev/root_vg/root";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/persist" = {
      device = "/dev/root_vg/root";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/home" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=25%" "mode=755"];
    };
  };

  users.users.anarcho = {
    isNormalUser = true;
    initialPassword = "pass";
    extraGroups = ["wheel" "networkmanager"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuUz6JTu3ZB93YDEtck7IxaZ6lKpAslwMls9IpTbpMN anarcho@nix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKq7kAc2P4mDl78iRDl/XItrac0BATHNNWWAFYuavlow anarcho@nixvm"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAOTruhS9onWl0QMqAB8Xv4sy8RtxfdfuZQxL0neu41L anarcho@nix"
    ];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  virtualisation.virtualbox.guest.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  system.stateVersion = "24.05";
}
