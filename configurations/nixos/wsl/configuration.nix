{
  imports = [
  ];

  time.timeZone = "Australia/Brisbane";

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "nixos";

  wsl = {
    enable = true;
    defaultUser = "aaronk";
    nativeSystemd = true;
  };

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  systemd.user.services.dbus = {
    wantedBy = ["default.target"];
  };

  environment.sessionVariables = {
    DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/users/1000/bus";
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.05";
}
