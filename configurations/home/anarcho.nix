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
  ];

  desktop.homemodules.wm = {
    defaultTerminal = "ghostty";
  };

  home.username = "anarcho";
  home.homeDirectory = "/home/anarcho";
  home.stateVersion = "24.11";
}
