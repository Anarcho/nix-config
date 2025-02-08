[
  {
    mode = "n";
    key = "<leader>;";
    action = "<cmd>Alpha<CR>";
    options = {
      desc = "Open dashboard";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>bd";
    action = "<cmd>bdelete<CR>";
    options = {
      desc = "Close current buffer";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>bs";
    action = "<cmd>FzfLua buffers<CR>";
    options = {
      desc = "Switch buffers";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<s-l>";
    action = "<cmd>BufferLineCycleNext<CR>";
    options = {
      desc = "Next tab";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<s-h>";
    action = "<cmd>BufferLineCyclePrev<CR>";
    options = {
      desc = "Previous tab";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<ESC>";
    action = ":nohlsearch<CR>";
    options = {
      silent = true;
    };
  }
]
