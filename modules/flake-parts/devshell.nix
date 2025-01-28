# modules/flake-parts/dev-shells.nix
{
  perSystem = {pkgs, ...}: {
    devShells = {
      # Your existing default shell
      default = pkgs.mkShell {
        name = "nixos-unified-template-shell";

        meta.description = "Shell environment for modifying this Nix configuration";
        packages = with pkgs; [
          just
          nixd
        ];
      };

      # Zig development environment
      zig = pkgs.mkShell {
        name = "zig-dev";

        packages = with pkgs; [
          zig
          zls
        ];
      };

      # C/C++ development environment
      cpp = pkgs.mkShell {
        name = "cpp-dev";
        packages = with pkgs; [
          gcc
          gdb
          cmake
          gnumake
          clang-tools # includes clangd language server
          bear # for generating compilation database
        ];
        shellHook = ''
          echo "C/C++ development environment loaded"
          echo "Tools available: gcc, gdb, cmake, make, clangd"

        '';
      };

      # Python development environment

      python = pkgs.mkShell {
        name = "python-dev";
        packages = with pkgs; [
          python3
          poetry
          black
          ruff
          python3Packages.pip
          python3Packages.virtualenv
          basedpyright # Python LSP
        ];
        LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
        shellHook = ''
          if [ ! -d "venv" ]; then
            echo "Creating new Python virtual environment..."
            virtualenv venv
          fi
          source venv/bin/activate
        '';
      };

      # Go development environment
      go = pkgs.mkShell {
        name = "go-dev";

        packages = with pkgs; [
          go
          gopls
          golangci-lint
          delve # Go debugger
        ];
        shellHook = ''
          export GOPATH="$PWD/.go"
          export PATH="$GOPATH/bin:$PATH"
        '';
      };

      # Bash development environment
      bash = pkgs.mkShell {
        name = "bash-dev";
        packages = with pkgs; [
          shellcheck
          shfmt
          nodePackages.bash-language-server
        ];
      };

      # Nix development environment
      nix = pkgs.mkShell {
        name = "nix-dev";
        packages = with pkgs; [
          nixpkgs-fmt

          nil # Nix Language Server
          nixd # Alternative Nix Language Server
          nix-direnv
          alejandra # Nix formatter
        ];
      };
    };
  };
}
