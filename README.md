# Setup

- Symlink the configuration files using `sudo ./symlink_files.sh`
- Follow the [SSH README](./ssh/README.md)

# Installation

- Run `home-manager switch ~/config` (afterwards, use `hms`)
- Run `sudo nixos-rebuild switch --flake ~/config` (afterwards, use `nos`)

# Upgrade

- First, update the lockfile with `nix flake update --flake ~/config`

## System
- Run `nos`

## Home Manager
- Run `hms`
