{ config, pkgs, upkgs, system, lib, inputs, ... }:

{

  imports = [
    ../shared/common
    ../shared/ssh_config
    ../shared/programs/direnv
    ../shared/programs/fish
    ../shared/programs/starship
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "andreas";
  home.homeDirectory = "/home/andreas";

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
  home.packages = with pkgs; [
      fastfetch
      ubuntu_font_family
      fira-code-nerdfont
      fira-mono
      git
      screen
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    (pkgs.writeShellScriptBin "hms" ''
      nh home switch -a
    '')
    (pkgs.writeShellScriptBin "nos" ''
      nh os switch -a
    '')
  ] ++ (with upkgs; [
    ffmpeg
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
    FLAKE = "/home/andreas/config";
    # EDITOR = "emacs";
  };

  shared.programs.direnv.enable = true;
  shared.programs.fish = {
    enable = true;
    isNixOS = true;
  };
  shared.programs.starship.enable = true;
}
