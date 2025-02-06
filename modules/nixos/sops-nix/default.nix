{
  flake,
  lib,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age
  ];
}
