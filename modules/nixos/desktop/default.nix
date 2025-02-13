{pkgs, ...}: {
  imports = [
    ./i3.nix
    ./bspwm.nix
    ./hyprland.nix
    ./sway.nix
  ];
}
