{
  imports = [
  ];

  time.timeZone = "Australia/Brisbane";

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "nixos";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = "aaronk";
    startMenuLaunchers = true;
  };

  environment.enableAllTerminfo = true;

  nix = {
    settings = {
      trusted-users = ["aaronk"];
      accept-flake-config = true;
      auto-optimise-store = true;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.05";
}
