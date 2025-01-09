{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.nixosModules.default
    self.nixosModules.wsl
    ./configuration.nix
  ];

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;

  nix = {
    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  # Enable home-manager for "anarcho" user
  home-manager.users."aaronk" = {
    imports = [(self + /configurations/home/aaronk.nix)];
  };
}
