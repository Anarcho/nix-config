# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

# Default command when 'just' is run without arguments
default:
  @just --list

# Update nix flake
[group('Main')]
update:
  nix flake update

# Lint nix files
[group('dev')]
lint:
  nix fmt

# Check nix flake
[group('dev')]
check:
  nix flake check

# Manually enter dev shell
[group('dev')]
dev:
  nix develop

# Activate the configuration
[group('Main')]
run:
  nix run

# Build and activate on remote VM
[group('Main')]
vm-rebuild:
  nix run nixpkgs#nixos-rebuild -- switch --target-host nix --flake '.#vm' --build-host nix --use-remote-sudo

# Just build on remote VM without activating
[group('Main')]
vm-build:
  nix run nixpkgs#nixos-rebuild -- build --target-host nix --flake '.#vm' --build-host nix --use-remote-sudo

# Copy configuration to remote VM and rebuild
[group('Main')]
vm-deploy: vm-rebuild

# Test the configuration on remote VM
[group('Main')]
vm-test:
  nix run nixpkgs#nixos-rebuild -- test --target-host nix --flake '.#vm' --build-host nix --use-remote-sudo
