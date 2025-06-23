{
  config,
  pkgs,
  upkgs,
  system,
  lib,
  inputs,
  ...
}: let
  nixgl = inputs.nixgl;
in {
  imports = [
    ../shared/common
    ../shared/genericlinux
    ../shared/ssh_config
    ../shared/programs/direnv
    ../shared/programs/fish
    ../shared/programs/starship
  ];

  shared.genericlinux.enable = true;

  nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "deck";
  home.homeDirectory = "/home/deck";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;
    [
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello
      (pkgs.writeShellScriptBin "hms" ''
        nh home switch -a
      '')
      (pkgs.writeShellScriptBin "sms" ''
        sudo -i nix run 'github:numtide/system-manager' -- switch --flake ~/config
      '')
      (pkgs.writeShellScriptBin "server" ''
        ssh -i ~/.ssh/andreas_ubuntu_ws andreas@localhost.onthewifi.com
      '')
      # Quick and dirty way to use NixGL
      (pkgs.writeShellScriptBin "nixgl" ''
        nix run --impure github:nix-community/nixGL -- $1
      '')
      (config.lib.nixGL.wrap vesktop)
      (config.lib.nixGL.wrap vscode)
      zotero
      dconf
      nixd
      tailscale
      (config.lib.nixGL.wrap (firefox.override {nativeMessagingHosts = [inputs.pipewire-screenaudio.packages.${pkgs.system}.default];}))
    ]
    ++ (with upkgs; [
      ]);

  shared.ssh_config.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/andreas/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    NH_FLAKE = "/home/deck/config";
  };

  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.package = pkgs.kdePackages.breeze;
  home.pointerCursor.name = "breeze_cursors";
  home.pointerCursor.size = 24;

  shared.programs.direnv.enable = true;
  shared.programs.fish = {
    enable = true;
    isNixOS = false;
  };
  shared.programs.starship.enable = true;

  programs.nh.enable = true;
}
