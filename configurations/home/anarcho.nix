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
  ];

  desktop.homemodules.wm = {
    defaultTerminal = "ghostty";
    wallpaperImage = "fantasy-woods.jpg";
    defaultBrowser = "firefox";
    defaultNotesApplication = "obsidian";
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
