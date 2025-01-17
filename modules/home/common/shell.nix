{
  lib,
  config,
  ...
}: {
  programs = {
    # on macOS, you probably don't need this
    bash = {
      enable = true;
      initExtra = ''
        export ANTHROPIC_API_KEY=$(cat ${config.sops.secrets.anthropic-key.path})
      '';
    };

    # For macOS's default shell.
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
      '';
      shellAliases = {
        rs = "sudo nixos-rebuild switch --flake .#wsl";
        jr = "just vm-rebuild";
        jc = "nix flake check";
      };
      history.size = 10000;
      history.ignoreAllDups = true;
      history.path = "$HOME/.config/.zsh_history";
      history.ignorePatterns = ["rm *" "pkill *" "cp *"];
      initExtra = ''
        export ANTHROPIC_API_KEY=$(cat ${config.sops.secrets.anthropic-key.path});
        bindkey -s '^f' 'tms\n'
      '';
      sessionVariables = {
        EDITOR = "vim";
      };
    };

    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;
  };
}
