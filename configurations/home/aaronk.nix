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
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets.anthropic-key = {
      sopsFile = "${inputs.mysecrets}/secrets.yaml";
    };
  };

  home.sessionVariables = {
    ANTHROPIC_API_KEY = config.sops.secrets.anthropic-key.path;
  };

  home.username = "aaronk";
  home.homeDirectory = "/home/aaronk";
  home.stateVersion = "24.11";
}
