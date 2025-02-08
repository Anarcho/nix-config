[
  {
    mode = "n";
    key = "<leader>xx";
    action = "<cmd>Trouble diagnostics toggle<cr>";
    options = {
      desc = "Diagnostics (Trouble)";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>xX";
    action = "<cmd>Trouble diagnostics toggle.buf=0<cr>";
    options = {
      desc = "Buffer diagnostics (Trouble)";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>cs";
    action = "<cmd>Trouble symbols toggle  focus=false<cr>";
    options = {
      desc = "Symbols (Trouble)";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>cl";
    action = "<cmd>Trouble symbols toggle  focus=false win.position=right<cr>";
    options = {
      desc = "LSP Definitions / references / ... (Trouble)";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>xL";
    action = "<cmd>Trouble loclist toggle<cr>";
    options = {
      desc = "Location list (Trouble)";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>xQ";
    action = "<cmd>Trouble qflist toggle<cr>";
    options = {
      desc = "Quickfix list (Trouble)";
      silent = true;
    };
  }
  {
    mode = "n";
    key = "<leader>xQ";
    action = "<cmd>Trouble qflist toggle<cr>";
    options = {
      desc = "Quickfix list (Trouble)";
      silent = true;
    };
  }
]
