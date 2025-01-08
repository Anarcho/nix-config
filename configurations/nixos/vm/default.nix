# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.nixosModules.default
    self.nixosModules.impermanence
    self.nixosModules.disko
    ./configuration.nix
  ];

  # Enable home-manager for "anarcho" user
  home-manager.users."anarcho" = {
    imports = [(self + /configurations/home/anarcho.nix)];
  };

  home-manager.backupFileExtension = "backup";
}
