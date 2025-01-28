{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Unix tools
    ripgrep # Better `grep`
    fd
    sd
    tree
    gnumake

    # Nix dev
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt
		alejandra
    yamlfmt
    just

    playerctl
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    btop.enable = true;
    tmate = {
      enable = true;
    };
  };
}
