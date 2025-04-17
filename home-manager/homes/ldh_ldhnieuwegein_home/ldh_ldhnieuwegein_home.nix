{
  config,
  pkgs,
  upkgs,
  system,
  lib,
  inputs,
  ...
}: let
  extensions = with pkgs.gnomeExtensions; [
    dash-to-dock
    caffeine
    appindicator
    just-perfection
    blur-my-shell
    smart-auto-move
  ];
in {
  imports = [
    ../../shared/common
    ../../shared/programs/direnv
    ../../shared/programs/fish
    ../../shared/programs/starship
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ldh";
  home.homeDirectory = "/home/ldh";

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
      fira-code-nerdfont
      fira-mono
      zenity
      git
      screen
      firefox
      onlyoffice-bin_latest
      inkscape
      (pkgs.callPackage /home/ldh/Data/simulacrum/build_nix/build.nix {})
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
        nh home switch -- --impure
      '')
      (pkgs.writeShellScriptBin "nos" ''
        nh os switch
      '')
    ]
    ++ (with upkgs; [
      ffmpeg
    ])
    ++ extensions;

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

    ".config/autostart/simulacrum.desktop".source = "${(pkgs.callPackage /home/ldh/Data/simulacrum/build_nix/build.nix {})}/share/applications/com.simulacrum.simulacrum.desktop";
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
    FLAKE = "/home/ldh/config";
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
    # Enable installed extensions
    "org/gnome/shell".enabled-extensions = map (extension: extension.extensionUuid) extensions;

    "org/gnome/shell".disabled-extensions = [];

    "org/gnome/shell".favorite-apps = [
      "firefox.desktop"
      "com.simulacrum.simulacrum.desktop"
      "org.gnome.Nautilus.desktop"
    ];

    "system/locale" = {
      region = "nl_NL.UTF-8";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
      font-name = "Ubuntu 11";
      document-font-name = "Ubuntu 11";
      monospace-font-name = "Ubuntu 11";
      font-antialiasing = "rgba";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${./assets/background}";
      picture-uri-dark = "file://${./assets/background}";
      primary-color = "#241f31";
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      center-new-windows = true;
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["terminate:ctrl_alt_bksp" "compose:ralt"];
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Ubuntu Bold 11";
    };
    "org/gnome/Console" = {
      use-system-font = false;
      custom-font = "FiraCode Nerd Font Mono 14";
    };
    "org/gnome/TextEditor" = {
      use-system-font = false;
      custom-font = "Fira Mono 14";
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      disable-overview-on-startup = true;
      click-action = "minimize-or-previews";
      dash-max-icon-size = 52;
      running-indicator-style = "DOTS";
      custom-background-color = true;
      background-color = "rgb(53,53,53)";
    };
    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      startup-status = 0; # Desktop
    };
    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      # Dark, slightly transparent
      style-dialogs = 3;
    };
    "org/gnome/shell/extensions/caffeine" = {
      toggle-shortcut = ["<Super>c"];
    };
    "org/gnome/nautilus/preferences" = {
      show-delete-permanently = true;
    };
    "org/gnome/shell/window-switcher" = {
      current-workspace-only = false;
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = ["<Super>Tab"];
      switch-windows = ["<Alt>Tab"];
      switch-applications-backward = ["<Shift><Super>Tab"];
      switch-windows-backward = ["<Shift><Alt>Tab"];
    };
    "org/gnome/shell/extensions/smart-auto-move" = {
      freeze-saves = true;
      sync-mode = "RESTORE";
      saved-windows = "{\"Simulacrum\":[{\"id\":4243934907,\"hash\":4243934907,\"sequence\":25,\"title\":\"Simulacrum\",\"workspace\":0,\"maximized\":3,\"fullscreen\":false,\"above\":false,\"monitor\":0,\"x\":0,\"y\":32,\"width\":1920,\"height\":1048,\"occupied\":true}],\"simulacrum_presenter\":[{\"id\":4243934908,\"hash\":4243934908,\"sequence\":26,\"title\":\"simulacrum_presenter\",\"workspace\":0,\"maximized\":3,\"fullscreen\":true,\"above\":false,\"monitor\":1,\"x\":1920,\"y\":0,\"width\":1920,\"height\":1080,\"occupied\":true}]}";
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
