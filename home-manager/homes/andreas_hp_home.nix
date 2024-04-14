{ config, pkgs, upkgs, system, lib, inputs, ... }:

{
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
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    (pkgs.writeShellScriptBin "hms" ''
    home-manager switch --flake ~/config
    '')
    (pkgs.writeShellScriptBin "server" ''
    ssh -i ~/.ssh/andreas_ubuntu_ws andreas@localhost.onthewifi.com
    '')
    direnv
    subtitleedit
    vesktop

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Required to autoload fonts from packages installed via Home Manager
  fonts.fontconfig.enable = true; 

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    # Needed for Fish completion
    ".config/fish/completions/nix.fish".source = "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";

    ".ssh/config" = {
      # source = ../ssh/config;
      text = ''
#private account
Host private
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_rsa_private

#school account
Host school
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_rsa_school

#igne account
Host igne
        HostName bitbucket.org
        User git
        IdentityFile ~/.ssh/id_rsa_school
      '';
      target = ".ssh/config_source";
      onChange = "cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config";
    };

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
  };
  
  programs.fish = {
    enable = true;
    # Needed for Fish shell managed by HM
    shellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end
    '';
    interactiveShellInit = ''
set fish_greeting # Disable greeting
    '';
  };
  
  programs.starship = {
    enable = true;
    settings = lib.importTOML ../starship.toml;
  };

  # Add command-not-found without using channels
  programs.command-not-found.dbPath = inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
  
	# Fix desktop entries not showing up in Gnome
	targets.genericLinux.enable = true;
	xdg.mime.enable = true;
	xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
