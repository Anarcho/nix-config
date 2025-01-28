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
    key = "<leader>wv";
    action = ":vsplit<CR>";
    options = {
      desc = "Split Vertical";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>wh";
    action = ":split<CR>";
    options = {
      desc = "Split Horizontal";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>wq";
    action = ":q<CR>";
    options = {
      desc = "Close Window";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<C-h>";
    action = "<C-w>h";
    options = {
      desc = "Move Left";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<C-j>";
    action = "<C-w>j";
    options = {
      desc = "Move Down";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<C-k>";
    action = "<C-w>k";
    options = {
      desc = "Move Up";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<C-l>";
    action = "<C-w>l";
    options = {
      desc = "Move Right";
      silent = true;
    };
  }
]
