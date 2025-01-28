{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.modules.shell.shell;
in {
  options.programs.modules.shell.shell = {
    enable = mkEnableOption "Enable shell system tools";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      starship
      nodejs_18
    ];

    programs.starship = {
      enable = true;
      presets = [
        "nerd-font-symbols"
        "gruvbox-rainbow"
      ];
      settings = {
        command_timeout = 10000;
        zig = {
          symbol = "";
        };
      };
    };
  };
}
