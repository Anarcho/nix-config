{
  lsp = {
    enable = true;
    inlayHints = false;
    servers = {
      ansiblels.enable = true;
      bashls.enable = true;
      ccls.enable = true;
      cssls.enable = true;
      emmet_ls.enable = true;
      golangci_lint_ls.enable = true;
      gopls.enable = true;
      html.enable = true;
      java_language_server.enable = false;
      jdtls.enable = false;
      jsonls.enable = true;
      lua_ls.enable = true;
      pylsp.enable = true;
      pylyzer.enable = false;
      ruff_lsp.enable = true;
      superhtml.enable = true;
      zls.enable = true;

      nixd = {
        enable = true;

        settings = {
          formatting.command = ["alejandra"];
          nixpkgs.expr = "import <nixpkgs> {}";
        };
      };

      yamlls = {
        enable = true;
        filetypes = ["yaml"];
      };
    };
  };
}
