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

  desktop.homemodules.notes = {
    obsidianVaultsEnabled = true;
    vaultPath = "/home/anarcho/obsidian";
    vaults = [
      {
        name = "personal";
      }
    ];
  };

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
