[
  {
    mode = "n";
    key = "<leader>zt";
    action = "<cmd>ZigTest<cr>";
    options = {
      desc = "Zig test";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>zb";
    action = "<cmd>ZigBuild<cr>";
    options = {
      desc = "Zig build commands";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>zr";
    action = "<cmd>ZigRun<cr>";
    options = {
      desc = "Zig Run";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>oo";
    action = "<cmd>OverseerToggleFzf<cr>";
    options = {
      desc = "Overseer (FZF)";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>or";
    action = "<cmd>OverseerRunFzf<cr>";
    options = {
      desc = "Overseer run (FZF)";
      silent = true;
    };
  }
]
