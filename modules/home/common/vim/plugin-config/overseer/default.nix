{
  overseer = {
    enable = true;
    settings = {
      strategy = "toggleterm";
      templates = [
        "builtin"
        "user.zig_test"
        "user.zig_build"
        "user.zig_run"
        "user.zig_test_build"
      ];
      # Add component configuration
      components = {
        on_output_quickfix = {
          enable = true;
        };
        default = [
          "on_exit_set_status"
          "on_complete_notify"
          "on_output_summarize"
          "on_result_diagnostics"
          "on_output_parse"
        ];
      };
      task_list = {
        bindings = {
          "<C-h>" = false;
          "<C-j>" = false;
          "<C-k>" = false;
          "<C-l>" = false;
        };
        form = {
          win_opts = {
            winblend = 0;
          };
        };
        confirm = {
          win_opts = {
            winblend = 0;
          };
        };
        task_win = {
          win_opts = {
            winblend = 0;
          };
        };
      };
    };
  };
}
