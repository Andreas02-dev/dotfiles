# Setup

- Symlink the configuration files using `sudo ./symlink_files.sh`
- Follow the [SSH README](./ssh/README.md)

# Installation

- Run `sudo nixos-rebuild switch` (afterwards, use `nos`)
- Run `home-manager switch` (afterwards, use `hms`)

# Upgrade

## System
- Run `cd ./etc/nixos && nix flake update`
- Run `nos`

## Home Manager
- Run `cd ./home-manager && nix flake update`
- Run `hms`
