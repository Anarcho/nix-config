{
  flake,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.common
    self.homeModules.home-only
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.username = "aaronk";
  home.homeDirectory = "/home/aaronk";
  home.stateVersion = "24.11";
}
