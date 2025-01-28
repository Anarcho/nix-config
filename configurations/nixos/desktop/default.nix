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
    self.nixosModules.desktop
    self.nixosModules.programs
    ./configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;

  desktop.modules.wm.bspwm = {
    enable = true;
    isVirtualMachine = true;
    videoDrivers = ["virtualbox"];
  };

  programs.modules.notes.obsidian.enable = true;
  programs.modules.music.spotify.enable = true;
  programs.modules.shell.shell.enable = true;

  # Enable home-manager for "anarcho" user
  home-manager.users."anarcho" = {
    imports = [(self + /configurations/home/anarcho.nix)];
  };

  home-manager.backupFileExtension = "backup";
}
