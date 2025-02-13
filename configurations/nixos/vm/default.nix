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
    self.nixosModules.disko
    self.nixosModules.desktop
    self.nixosModules.programs
    ./configuration.nix
  ];

  desktop.modules.services.disko = {
    enable = true;
    strategy = "vm";
  };
  desktop.modules.wm.sway = {
    enable = true;
    isVirtualMachine = true;
  };

  nixpkgs.config.allowUnfree = true;

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;

  programs.modules.shell.shell.enable = true;

  # Enable home-manager for "anarcho" user
  home-manager.users."ak-test" = {
    imports = [(self + /configurations/home/ak-test.nix)];
  };
  home-manager.backupFileExtension = "backup";
}
