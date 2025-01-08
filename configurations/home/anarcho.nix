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
    self.homeModules.nix
  ];

  home.username = "anarcho";
  home.homeDirectory = "/home/anarcho";
  home.stateVersion = "24.11";
}
