{
  imports = [
    ./polybar.nix
  ];
  systemd.user.services.polybar = {
    Install.WantedBy = ["graphical-session.target"];
  };
}
