{
  alpha = {
    enable = true;
    theme = null;
    layout = [
      {
        type = "padding";
        val = 2;
      }
      {
        opts = {
          hl = "type";
          position = "center";
        };
        type = "text";
        val = [
          "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
          "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
          "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
          "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
          "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "button";
        val = "󰈞 Find File";
        on_press.raw = "FzfLua files";

        opts = {
          keymap = [
            "n"
            "f"
            ":FzfLua files<CR>"
            {
              noremap = true;
              silent = true;
              nowait = true;
            }
          ];
          shortcut = "f";
          position = "center";
          cursor = 3;
          width = 38;
          align_shortcut = "right";
          hl_shortcut = "Keyword";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "button";

        val = "󰥨 Recent Project Files";
        on_press.raw = "FzfLua oldfiles cwd_only=true";
        opts = {
          keymap = [
            "n"
            "r"
            ":FzfLua oldfiles cwd_only=true<CR>"
            {
              noremap = true;
              silent = true;
              nowait = true;
            }
          ];
          shortcut = "r";
          position = "center";
          cursor = 3;
          width = 38;
          align_shortcut = "right";
          hl_shortcut = "Keyword";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "button";
        val = "󰋚 Recent Files";
        on_press.raw = "FzfLua oldfiles";
        opts = {
          keymap = [
            "n"
            "R"
            ":FzfLua oldfiles<CR>"

            {
              noremap = true;
              silent = true;

              nowait = true;
            }
          ];
          shortcut = "R";
          position = "center";
          cursor = 3;
          width = 38;
          align_shortcut = "right";
          hl_shortcut = "Keyword";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "button";
        val = "󰗼 Quit NVIM";
        on_press.raw = "qa!";
        opts = {
          keymap = [
            "n"
            "q"
            ":qa!<CR>"
            {
              noremap = true;
              silent = true;
              nowait = true;
            }
          ];
          shortcut = "q";
          position = "center";
          cursor = 3;
          width = 38;
          align_shortcut = "right";
          hl_shortcut = "Keyword";
        };
      }
    ];
  };
}

