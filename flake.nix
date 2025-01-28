{
  description = "Anarcho's Flake Config";

  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOs-WSL/main";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";

    impermanence.url = "github:nix-community/impermanence";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";

    # Nix Colors
    nix-colors.url = "github:misterio77/nix-colors";

    # Software inputs
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # TMUX Sessionizer
    tmux-sessionizer.url = "github:jrmoulton/tmux-sessionizer";
    tmux-sessionizer.inputs.nixpkgs.follows = "nixpkgs";
    tmux-sessionizer.inputs.flake-parts.follows = "flake-parts";

    # NVF
    nvf.url = "github:notashelf/nvf";

    #Neovim
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # Secrets path
    mysecrets.url = "git+ssh://git@github.com/Anarcho/nix-secrets.git?shallow=1";
    mysecrets.flake = false;
  };

  # Wired using https://nixos-unified.org/autowiring.html
  outputs = inputs:
    inputs.nixos-unified.lib.mkFlake
    {
      inherit inputs;
      root = ./.;
    };
}
