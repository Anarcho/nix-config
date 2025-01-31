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

  home.persistence."/persist/home/anarcho" = {
    allowOther = true;
    directories = [
      "Repos"
      ".config"
      ".ssh"
      ".cache"
      ".local/share"
    ];

    files = [
      ".bash_history"
      ".zsh_history"
      ".xinitrc"
      ".Xresources"
      ".Xauthority"
    ];
  };

  common.modules.editor.nixvim.enable = false;
  common.modules.editor.nvf.enable = true;

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
