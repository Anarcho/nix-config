{
  imports = [
    ./polybar.nix
    ./picom.nix
    ./rofi.nix
    ./fastfetch.nix
  ];
  systemd.user.services.polybar = {
    Install.WantedBy = ["graphical-session.target"];
  };
}
