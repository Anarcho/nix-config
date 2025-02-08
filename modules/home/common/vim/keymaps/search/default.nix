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
  {
    mode = "n";
    key = "<leader>fr";
    action = ":FzfLua oldfiles cwd_only=true<CR>";
    options = {
      desc = "Search in buffer";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>dl";
    action = ":FzfLua diagnostic_document<CR>";
    options = {
      desc = "List diagnostic document";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>dw";
    action = ":FzfLua diagnostic_workspace<CR>";
    options = {
      desc = "Workspace diagnostic";
      silent = true;
    };
  }
]
