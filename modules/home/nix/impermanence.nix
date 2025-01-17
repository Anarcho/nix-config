{flake, ...}: {
  imports = [
    flake.inputs.impermanence.homeManagerModules.impermanence
  ];

  home.persistence = {
    "/home/anarcho" = {
      allowOther = true;
      directories = [
        "Repos"
        "test"
        ".config/nvim"
        ".config/sops"
        ".config/sops-nix"
        ".config/zsh"
        ".ssh"
        "test"
      ];

      files = [
        ".bash_history"
        ".bash_logout"
      ];
    };
  };
}
