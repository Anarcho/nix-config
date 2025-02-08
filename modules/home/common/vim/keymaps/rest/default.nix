[
  {
    mode = "n";
    key = "<leader>hr";
    action = "<cmd>Rest run<cr>";
    options = {
      desc = "Run request under cursor";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>hl";
    action = "<cmd>Rest last<cr>";
    options = {
      desc = "Re-run last request";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>he";
    action = "<cmd>Rest env show<cr>";
    options = {
      desc = "Edit environment file";
      silent = true;
    };
  }
]
