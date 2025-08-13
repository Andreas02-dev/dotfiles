{
  config,
  pkgs,
  upkgs,
  system,
  lib,
  inputs,
  ...
}:
let
  chromium86 = inputs.chromium-86.legacyPackages.x86_64-linux.chromium;
  chromium86Wrapper = pkgs.writeShellScriptBin "chromium86" ''
    exec ${chromium86}/bin/chromium "$@"
  '';
in
 {
  imports = [
    ../shared/common
    ../shared/programs/direnv
    ../shared/programs/fish
    ../shared/programs/starship
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

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
      fastfetch
      ubuntu_font_family
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      zenity
      git
      screen
      wget
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
    (pkgs.writeShellScriptBin "rzi" ''
      find . -type f -name '*:Zone.Identifier' -exec rm -f {} +
    '')
    (pkgs.writeShellScriptBin "lock" ''
      pkill -u "$(whoami)" -f gnome-keyring-daemon
    '')
    (pkgs.writeShellScriptBin "unlock" ''
      read -rsp "keyring password:" keyringPass
      echo -n "$keyringPass" | gnome-keyring-daemon -dr --unlock
      unset keyringPass
    '')
    (pkgs.writeShellScriptBin "code" ''
      exec "/mnt/c/Users/AndreasH/AppData/Local/Programs/Microsoft VS Code/bin/code" "$@"
    '')
  ] ++ (with upkgs; [
    ffmpeg
  ]) ++ [
    inputs.chromium-109.legacyPackages.x86_64-linux.chromium
    chromium86Wrapper
  ];

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
    NH_FLAKE = "/home/nixos/config";
    SSH_SK_HELPER="/mnt/c/Windows/System32/OpenSSH/ssh-sk-helper.exe";
    # EDITOR = "emacs";
  };

  shared.programs.direnv.enable = true;
  shared.programs.fish = {
    enable = true;
    isNixOS = true;
  };
  shared.programs.starship.enable = true;

  dconf.settings = let
    inherit (lib.hm.gvariant) mkTuple mkUint32 mkVariant mkDictionaryEntry mkDouble;
  in {
    "system/locale" = {
      region = "nl_NL.UTF-8";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      font-name = "Ubuntu 11";
      document-font-name = "Ubuntu 11";
      monospace-font-name = "Ubuntu 11";
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["terminate:ctrl_alt_bksp" "compose:ralt"];
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Ubuntu Bold 11";
    };
    "org/gnome/Console" = {
      use-system-font = false;
      custom-font = "FiraMono Nerd Font Mono 14";
    };
    "org/gnome/TextEditor" = {
      use-system-font = false;
      custom-font = "FiraMono Mono 14";
    };
  };
  #
  gtk = {
    enable = true;

    iconTheme = {
      name = "Yaru-blue-dark";
      package = pkgs.yaru-theme;
    };

    theme = {
      name = "Yaru-blue-dark";
      package = pkgs.yaru-theme;
    };

    cursorTheme = {
      name = "Yaru";
      package = pkgs.yaru-theme;
    };
  };

  #home.sessionVariables.GTK_THEME = "Yaru-blue-dark";
  #
}
