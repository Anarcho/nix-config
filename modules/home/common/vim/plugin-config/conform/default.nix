{
  conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        "_" = ["trim_whitespace"];
        go = ["goimports" "golines" "gofmt" "gofumpt"];
        lua = ["stylua"];
        python = ["isort" "black"];
        sh = ["shfmt"];
        terrafrom = ["terraform_fmt"];
        nix = ["alejandra"];
        zig = ["zigfmt"];
      };
      format_after_save.lsp_format = "fallback";
    };
  };
}
