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
    inputs.impermanence.homeManagerModules.impermanence
  ];

  desktop.homemodules.wm = {
    defaultTerminal = "ghostty";
    wallpaperImage = "gruv-forest.png";
    defaultBrowser = "firefox";
    enablePolybar = true;
    enablePicom = true;
    enableRofi = true;
    enableFastfetch = true;
    colorScheme = "gruvbox-dark-medium";
  };

  common.modules.editor.nixvim.enable = true;
  common.modules.editor.nvf.enable = false;

  home.username = "anarcho";
  home.homeDirectory = "/home/anarcho";

  home.file = {
    ".config/assets" = {
      source = ../../assets;
      recursive = true;
    };
  };

  home.stateVersion = "24.11";
}
