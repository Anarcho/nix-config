{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.nameservers = ["8.8.8.8" "1.1.1.1" "8.8.4.4"];

  time.timeZone = "Australia/Brisbane";

  nixpkgs.hostPlatform = {system = "x86_64-linux";};

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=25%" "mode=755"];
  };

  fileSystems."/persist" = {
    device = "/dev/root_vg/root";
    neededForBoot = true;
    fsType = "btrfs";
    options = ["subvol=persist"];
  };

  fileSystems."/nix" = {
    device = "/dev/root_vg/root";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };
  fileSystems."/home" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=25%" "mode=755"];
    neededForBoot = true;
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
