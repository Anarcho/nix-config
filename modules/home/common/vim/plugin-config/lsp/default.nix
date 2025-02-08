{pkgs, ...}: {
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
      java_language_server.enable = false;
      jdtls.enable = false;
      lua_ls.enable = true;
      pylsp.enable = true;
      pylyzer.enable = false;
      ruff.enable = true;
      zls = {
        enable = true;
        extraOptions = {
          zls = {
            enable_snippets = true;
          };
        };
      };
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
      html = {
        enable = true;
        filetypes = ["http"];
        cmd = ["${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server" "--stdio"];
        rootDir.__raw = "function() return vm.fn.getcwd() end";
        settings = {
          init_options = {
            provideFormatter = false;
            embeddedLanguages = {http = true;};
            configurationSection = ["http" "html"];
          };
        };
      };
      jsonls = {
        enable = true;
        filetypes = ["json" "jsonc"];
        cmd = ["${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server" "--stdio"];
        settings = {
          init_options = {
            provideFormatter = true;
            validate = {
              enable = true;
            };
            json = {
              schemas.__raw = "require('schemastore').json.schemas()";
              validate = {
                enable = true;
              };
            };
          };
        };
      };
    };
  };
  schemastore = {
    enable = true;
    json.enable = true;
  };
}
