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
  ];

  common.modules.editor.nvf.enable = true;
  common.modules.editor.nixvim.enable = false;

  home.username = "aaronk";
  home.homeDirectory = "/home/aaronk";
  home.stateVersion = "25.05";
}
