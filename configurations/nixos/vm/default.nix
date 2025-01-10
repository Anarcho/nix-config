# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{
  flake,
  config,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.nixosModules.default
    self.nixosModules.impermanence
    self.nixosModules.disko
    self.nixosModules.desktop
    self.nixosModules.programs
    ./configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;

  desktop.modules.wm.i3 = {
    enable = true;
    isVirtualMachine = true;
    videoDrivers = ["virtualbox"];
  };

  programs.modules.notes.obsidian.enable = true;

  # Enable home-manager for "anarcho" user
  home-manager.users."anarcho" = {
    imports = [(self + /configurations/home/anarcho.nix)];
  };

  home-manager.backupFileExtension = "backup";
}
