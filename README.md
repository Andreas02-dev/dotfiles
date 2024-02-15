# Setup

- Set up the nixos unstable channel using `sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixos-unstable`
- Symlink the configuration files using `sudo ./symlink_files.sh`
- Follow the [SSH README](./ssh/README.md)

# Installation

- Run `sudo nixos-rebuild switch` (afterwards, use `nos`)
- Run `home-manager switch` (afterwards, use `hms`)

# Upgrade

- Run `sudo nix-channel --update`
- Run `nos`
- Run `hms`
