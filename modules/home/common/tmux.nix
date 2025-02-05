{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
in {
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";

    mouse = true;
    prefix = "C-a";

    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }

      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-internal '60'
        '';
      }
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox 'dark'

        '';
      }
    ];

    extraConfig = ''
      bind | split-window -h
      bind - split-window -v

      unbind '"'
      unbind %

      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pan -D
      bind -r h select-pane -L
      bind -r l select-pane -R


      # Tmux-Sessionizer

      bind C-f display-popup -E "tms"
      bind C-s display-popup -E "tms switch"

      bind C-w display-popup -E "tms windows"
      set -g status-right "#(tms sessions)"
      bind -r '(' switch-client -p\; refresh-client -S
      bind -r ')' switch-client -n\; refresh-client -S
      bind C-r command-prompt -p "Rename active session to:" "run-shell 'tms rename %%'"
    '';
  };

  home.packages = with pkgs; [
    fzf
  ];
}
