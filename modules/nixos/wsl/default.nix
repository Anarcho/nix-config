{flake, ...}: let
  inherit (flake) inputs;
in {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];
  system.stateVersion = "25.05";
  wsl.enable = true;
}
