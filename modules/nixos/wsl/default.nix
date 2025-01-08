{flake, ...}: let
  inherit (flake) inputs;
in {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];
  system.stateVersion = "24.05";
  wsl.enable = true;
}
