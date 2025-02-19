# Like GNU `make`, but `just` rustier.
# https://just.systems/

# Default command shows available commands
default:
    @just --list

# Update all flake inputs
[group('flake')]
update:
    nix flake update

# Check flake for errors
[group('flake')]
check:
    nix flake check

# Build and activate WSL configuration
[group('wsl')]
wsl-switch:
    sudo nixos-rebuild switch --flake '.#wsl'

# Test WSL configuration without activating
[group('wsl')]
wsl-test:
    sudo nixos-rebuild test --flake '.#wsl'

# Just build WSL configuration
[group('wsl')]
wsl-build:
    sudo nixos-rebuild build --flake '.#wsl'

# Build and activate desktop configuration
[group('desktop')]
desktop-switch:
    sudo nixos-rebuild switch --flake '.#desktop'

# Test desktop configuration without activating
[group('desktop')]
desktop-test:
    sudo nixos-rebuild test --flake '.#desktop'

# Just build desktop configuration
[group('desktop')]
desktop-build:
    sudo nixos-rebuild build --flake '.#desktop'
