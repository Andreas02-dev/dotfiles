# Setup

- Follow the [SSH README](./ssh/README.md)

# Installation

- Run `home-manager switch ~/config` (afterwards, use `hms`)

## NixOS
- Run `sudo nixos-rebuild switch --flake ~/config` (afterwards, use `nos`)

## Non-NixOS
- Don't forget to add the shell as a valid login shell by modifying `/etc/shells` to add `/home/$USER/.nix-profile/bin/fish`, where $USER should be replaced with your user. After performing this, `chsh -s /home/$USER/.nix-profile/bin/fish $USER` should be executed to change the shell for the user.

# Upgrade

- First, update the lockfile with `nix flake update --flake ~/config`

## System
- Run `nos`

## Home Manager
- Run `hms`
