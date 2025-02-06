{
  lib,
  config,
  pkgs,
  ...
}: {
  programs = {
    # on macOS, you probably don't need this
    bash = {
      enable = true;
      initExtra = ''
      '';
    };

    # For macOS's default shell.
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      dotDir = ".config/zsh";
      envExtra = ''
      '';
      shellAliases = {
        rs = "sudo nixos-rebuild switch --flake .#wsl";
        jr = "just vm-rebuild";
        jc = "nix flake check";
        zigdev = "nix develop anarcho#zig -c $SHELL";
      };
      history.size = 10000;
      history.ignoreAllDups = true;
      history.path = "$ZDOTDIR/.zsh_history";
      history.ignorePatterns = ["rm *" "pkill *" "cp *"];
      initExtra = ''
        bindkey -s '^f' 'tms\n'
        bindkey -s '^x' 'clear\n'
      '';
      sessionVariables = {
        EDITOR = "vim";
      };
    };

    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;
  };
}
