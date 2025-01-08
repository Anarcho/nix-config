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
    self.homeModules.default
    self.homeModules.home-only
  ];

  home.username = "aaronk";
  home.homeDirectory = "/home/aaronk";
  home.stateVersion = "24.11";
}
