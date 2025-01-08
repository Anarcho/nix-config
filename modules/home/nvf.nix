{flake, ...}: {
  imports = [
    flake.inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = false;
        vimAlias = true;

        # Settings

        # Theme
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        # LSP
        languages = {
          enableLSP = true;
          enableTreesitter = true;

          nix.enable = true;
          rust.enable = true;
          zig.enable = true;
          python.enable = true;
          clang.enable = true;
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;

        # Copilot
        assistant.copilot = {
          enable = true;
          cmp.enable = true;
        };

        dashboard = {
          dashboard-nvim = {
            enable = true;
          };
        };
      };
    };
  };
}
