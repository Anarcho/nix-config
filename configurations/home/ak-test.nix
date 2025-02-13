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
    self.homeModules.nix
    inputs.nix-colors.homeManagerModules.default
  ];
  common.modules.editor.nixvim.enable = true;
  home.username = "ak-test";
  home.homeDirectory = "/home/ak-test";
  home.stateVersion = "24.11";
}
