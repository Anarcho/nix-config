{pkgs, ...}: {
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
      options = ["defaults" "size=4G" "mode=755"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/3E44-D6DE";
      fsType = "vfat";
      options = ["defaults"];
      neededForBoot = true;
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/795a58b9-a5fe-488c-b26e-36331f121162";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/795a58b9-a5fe-488c-b26e-36331f121162";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/home/anarcho" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=25%" "mode=755"];
      neededForBoot = true;
    };
  };

  users.users.anarcho = {
    isNormalUser = true;
    initialPassword = "pass";
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager" "audio"];
    home = "/home/anarcho";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuUz6JTu3ZB93YDEtck7IxaZ6lKpAslwMls9IpTbpMN anarcho@nix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKq7kAc2P4mDl78iRDl/XItrac0BATHNNWWAFYuavlow anarcho@nixvm"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAOTruhS9onWl0QMqAB8Xv4sy8RtxfdfuZQxL0neu41L anarcho@nix"
    ];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services = {
    pulseaudio = {
      enable = false;
      extraModules = [pkgs.pulseaudio-modules-bt];
    };
  };

  # Enable audio through pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
    rtkit.enable = true;
    polkit.enable = true;
  };

  system.stateVersion = "24.05";
}
