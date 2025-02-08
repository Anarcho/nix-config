{
  cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      snippet = {
        expand = "function(args) require('luasnip').lsp_expand(args.body) end";
      };

      formatting = {
        fields = [
          "abbr"
          "kind"
          "menu"
        ];
      };
      sources = [
        {name = "nvim_lsp";}
        {name = "luasnip";}
        {name = "path";}
        {name = "buffer";}
      ];

      view.docs.auto_open = true;

      mapping = {
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-u>" = "cmp.mapping.scroll_docs(-4)";
        "<C-d>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
      };
    };
  };

  cmp-nvim-lsp.enable = true;
  cmp-nvim-lua.enable = true;
  cmp-path.enable = true;
  cmp-dictionary.enable = true;
  cmp-cmdline.enable = true;
  cmp-nvim-lsp-signature-help.enable = true;
  nvim-snippets.enable = true;
  nvim-snippets.settings.global_snippets = ["all"];
  nvim-snippets.settings.create_cmp_souurce = true;
}
