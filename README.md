# Setup

- Symlink the configuration files using `sudo ./symlink_files.sh`
- Follow the [SSH README](./ssh/README.md)

# Installation

- Run `sudo nixos-rebuild switch` (afterwards, use `nos`)
- Run `home-manager switch` (afterwards, use `hms`)

# Upgrade

- Run `sudo nix-channel --update`
- Run `nos`
- Run `hms`
