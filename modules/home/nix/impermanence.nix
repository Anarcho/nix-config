{flake, ...}: {
  imports = [
    flake.inputs.impermanence.homeManagerModules.impermanence
  ];

  home.persistence = {
    "/home/anarcho" = {
      allowOther = true;
      directories = [
        "Repos"
        "Documents"
        "test"
        ".config/nvim"
        ".config/obsidian"
        ".config/sops"
        ".config/sops-nix"
        ".config/assets"
        ".ssh"
        "test"
      ];

      files = [
        ".bash_history"
        ".bash_logout"
        ".zsh_history"
      ];
    };
  };
}
