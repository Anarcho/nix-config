{lib, ...}: {
  programs = {
    # on macOS, you probably don't need this
    bash = {
      enable = true;
      initExtra = ''
        # Custom bash profile goes here
      '';
    };

    # For macOS's default shell.
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        ANTHROPIC_API_KEY=$(cat ~/key.txt | tr -d '\n')
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
