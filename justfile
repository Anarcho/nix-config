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
wsl:
    sudo nixos-rebuild switch --flake '.#wsl'

# Build and activate desktop configuration
[group('desktop')]
desktop:
    sudo nixos-rebuild switch --flake '.#desktop'

