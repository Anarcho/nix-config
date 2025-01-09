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
    ./configuration.nix
  ];
  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;

  desktop.modules.wm.i3 = {
    enable = true;
    isVirtualMachine = true;
    videoDrivers = ["virtualbox"];
  };

  # Enable home-manager for "anarcho" user
  home-manager.users."anarcho" = {
    imports = [(self + /configurations/home/anarcho.nix)];
  };

  home-manager.backupFileExtension = "backup";
}
