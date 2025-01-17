{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (flake) inputs;
  inherit (inputs) self;
  cfg = config.desktop.homemodules.terminals;
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./terminals
  ];

  options.desktop.homemodules.terminals = {
    terminal = mkOption {
      type = types.str;
      default = "ghostty";

      description = "Terminal to install";
    };
  };

  config = mkMerge [
    (mkIf (cfg.terminal == "ghostty") {
      desktop.homemodules.terminals.modules.ghostty.enable = true;
    })
  ];
}

