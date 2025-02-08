{
  flake,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.common.modules.editor.nixvim;
in {
  imports = [
    flake.inputs.nixvim.homeManagerModules.nixvim
  ];
  options.common.modules.editor.nixvim = {
    enable = mkEnableOption "Enable NixVim configuration";
  };
  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      colorschemes.gruvbox.enable = true;
      clipboard.register = "unnamedplus";

      globals = {
        localleader = " ";
        mapleader = " ";
        markdown_folding = true;
      };

      opts = {
        autoindent = true;
        backspace = "indent,eol,start";
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        tabstop = 2;
        undofile = true;
        smartcase = true;
        termguicolors = true;
        ignorecase = true;
      };
      autoCmd = [
        {
          event = ["TextYankPost"];
          pattern = ["*"];
          command = "silent! lua vim.highlight.on_yank()";
        }
      ];

      extraPackages = with pkgs; [
        black
        isort
        jq
        nixpkgs-fmt
        vscode-langservers-extracted
        nodePackages.prettier
        prettierd
        stylua
        zls
      ];

      keymaps =
        []
        ++ import ./vim/keymaps/buffer
        ++ import ./vim/keymaps/cmp
        ++ import ./vim/keymaps/diagnostics
        ++ import ./vim/keymaps/directories
        ++ import ./vim/keymaps/lsp
        ++ import ./vim/keymaps/rest
        ++ import ./vim/keymaps/search
        ++ import ./vim/keymaps/sql
        ++ import ./vim/keymaps/terminal
        ++ import ./vim/keymaps/window;

      plugins =
        {
          lspkind.enable = true;
          lspsaga.enable = true;
          lualine.enable = true;
          web-devicons.enable = true;
          alpha.enable = true;
          fzf-lua.enable = true;
          comment.enable = true;
          zig.enable = true;
          nix.enable = true;
          vim-be-good.enable = true;
          treesitter-refactor.enable = true;
          treesitter-textobjects.enable = true;
          ts-autotag.enable = true;
          ts-context-commentstring.enable = true;
          render-markdown.enable = true;
          friendly-snippets.enable = true;
        }
        // (import ./vim/plugin-config/lsp) {inherit pkgs;}
        #// (import ./vim/plugin-config/blink-cmp)
        // (import ./vim/plugin-config/dadbod)
        // (import ./vim/plugin-config/luasnip)
        // (import ./vim/plugin-config/lualine)
        // (import ./vim/plugin-config/alpha)
        // (import ./vim/plugin-config/oil)
        // (import ./vim/plugin-config/neotest)
        // (import ./vim/plugin-config/mini)
        // (import ./vim/plugin-config/notify)
        // (import ./vim/plugin-config/none-ls)
        // (import ./vim/plugin-config/nvim-cmp)
        // (import ./vim/plugin-config/noice) {inherit pkgs;}
        // (import ./vim/plugin-config/overseer)
        // (import ./vim/plugin-config/toggleterm)
        // (import ./vim/plugin-config/treesitter) {inherit pkgs;}
        // (import ./vim/plugin-config/treesitter-context)
        // (import ./vim/plugin-config/bufferline)
        // (import ./vim/plugin-config/conform)
        // (import ./vim/plugin-config/autopairs)
        // (import ./vim/plugin-config/rest)
        // (import ./vim/plugin-config/trouble)
        // (import ./vim/plugin-config/which-key);
    };
  };
}
