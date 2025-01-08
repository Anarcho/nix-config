{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.nixosModules.default
    self.nixosModules.wsl
    ./configuration.nix
  ];

  # Enable home-manager for "anarcho" user
  home-manager.users."aaronk" = {
    imports = [(self + /configurations/home/aaronk.nix)];
  };

  home-manager.backupFileExtension = "backup";
}
