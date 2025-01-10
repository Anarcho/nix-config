{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  cfg = config.desktop.homemodules.notes;
  generateId = str: builtins.substring 0 16 (builtins.hashString "md5" str);

  makeWorkspaceConfig = name: let
    mainId = generateId "${name}-main";
    mainTabsId = generateId "${name}-main-tabs";
    mainLeafId = generateId "${name}-main-leaf";
    leftId = generateId "${name}-left";
    leftTabsId = generateId "${name}-left-tabs";
    explorerLeafId = generateId "${name}-explorer";

    rightId = generateId "${name}-right";
    rightTabsId = generateId "${name}-right-tabs";
    backlinkId = generateId "${name}-backlink";
  in {
    main = {
      id = mainId;
      type = "split";
      children = [
        {
          id = mainTabsId;
          type = "tabs";
          children = [
            {
              id = mainLeafId;
              type = "leaf";
              state = {
                type = "empty";
                state = {};
              };
            }
          ];
        }
      ];
      direction = "vertical";
    };
    left = {
      id = leftId;
      type = "split";
      children = [
        {
          id = leftTabsId;
          type = "tabs";
          children = [
            {
              id = explorerLeafId;
              type = "leaf";
              state = {
                type = "file-explorer";
                state = {
                  sortOrder = "alphabetical";
                };
              };
            }
          ];
        }
      ];
      direction = "horizontal";
      width = 300;
    };
    right = {
      id = rightId;
      type = "split";
      children = [
        {
          id = rightTabsId;
          type = "tabs";
          children = [
            {
              id = backlinkId;
              type = "leaf";

              state = {
                type = "backlink";
                state = {
                  collapseAll = false;
                  extraContext = false;
                  sortOrder = "alphabetical";
                  showSearch = false;

                  searchQuery = "";
                  backlinkCollapsed = false;
                  unlinkedCollapsed = true;

                };
              };
            }
          ];
        }
      ];
      direction = "horizontal";
      width = 300;
      collapsed = true;
    };
    active = mainLeafId;
  };

  vaultType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "Name of the vault";
      };
    };
  };
in {
  options.desktop.homemodules.notes = {
    obsidianVaultsEnabled = mkOption {
      type = types.bool;
      default = false;

      description = "Whether to enable Obsidian vault management";
    };

    vaultPath = mkOption {
      type = types.str;

      default = "${config.home.homeDirectory}/obsidian";
      description = "Base path for Obsidian vaults";
    };

    vaults = mkOption {
      type = types.listOf vaultType;
      default = [];
      description = "List of vaults to create";
    };
  };

  config = mkIf (
    (builtins.elem pkgs.obsidian osConfig.environment.systemPackages) &&
    cfg.obsidianVaultsEnabled
  ) {
    home.file = lib.mkMerge (map (vault: {
      "${cfg.vaultPath}/${vault.name}/.obsidian/app.json".text = builtins.toJSON {
        "attachmentFolderPath" = "attachments";
        "newFileFolderPath" = "";
        "useMarkdownLinks" = true;
        "showFrontmatter" = true;
      };


      "${cfg.vaultPath}/${vault.name}/.obsidian/appearance.json".text = builtins.toJSON {
        "baseFontSize" = 16;
        "theme" = "obsidian";
      };


      "${cfg.vaultPath}/${vault.name}/.obsidian/workspace.json".text = builtins.toJSON (makeWorkspaceConfig vault.name);

      "${cfg.vaultPath}/${vault.name}/.obsidian/core-plugins.json".text = builtins.toJSON [
        "file-explorer"
        "search"
        "page-preview"
        "backlink"
        "daily-notes"
        "templates"
      ];

      # Create necessary directories
      "${cfg.vaultPath}/${vault.name}/daily/.gitkeep".text = "";
      "${cfg.vaultPath}/${vault.name}/attachments/.gitkeep".text = "";

      "${cfg.vaultPath}/${vault.name}/templates/.gitkeep".text = "";

      # Add basic templates
      "${cfg.vaultPath}/${vault.name}/templates/daily.md".text = ''
        # Daily Note - {{date}}


        ## Tasks
        - [ ] 

        ## Notes

      '';

      "${cfg.vaultPath}/${vault.name}/templates/default.md".text = ''
        # {{title}}

        Created: {{date}}


        ## Notes
      '';
    }) cfg.vaults);
  };
}
