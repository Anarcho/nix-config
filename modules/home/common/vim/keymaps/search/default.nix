[
  {
    mode = "n";
    key = "<leader><leader>";
    action = "<cmd>FzfLua files<CR>";
    options = {
      desc = "Find files";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>/";
    action = ":FzfLua grep_curbuf<CR>";
    options = {
      desc = "Search in buffer";
      silent = true;
    };
  }
]
