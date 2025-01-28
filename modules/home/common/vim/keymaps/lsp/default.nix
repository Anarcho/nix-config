[
  {
    mode = "n";
    key = "gd";
    action = "<cmd>Lspsaga goto_definition<cr>";
    options = {
      desc = "Goto definition of highlighted item";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "gD";
    action = "<cmd>Lspsaga goto_type_definition<cr>";
    options = {
      desc = "Goto type definition of highlighted item";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "K";
    action = "<cmd>Lspsaga hover_doc<cr>";
    options = {
      desc = "Show lsp hover docs";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>lc";
    action = "<cmd>Lspsaga code_action<cr>";
    options = {
      desc = "Code Action";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>lff";
    action = "<cmd>Lspsaga finder<cr>";
    options = {
      desc = "Finder";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>lfi";
    action = "<cmd>Lspsaga imp<cr>";
    options = {
      desc = "Find implementation";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>lr";
    action = "<cmd>Lspsaga rename<cr>";
    options = {
      desc = "Rename";
      silent = true;
    };
  }
]
