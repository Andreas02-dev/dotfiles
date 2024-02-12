{ config, pkgs, ... }:
let extensions = with pkgs.gnomeExtensions; [
  dash-to-dock
  caffeine
  appindicator
];
in
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
  home.packages = [
      pkgs.firefox
      pkgs.fastfetch
      pkgs.discord
      pkgs.ubuntu_font_family
      pkgs.fira-code-nerdfont
      pkgs.fira-mono
      pkgs.gnome.gnome-terminal
      pkgs.direnv
      pkgs.nix-index
      pkgs.gnome.zenity
      pkgs.nextcloud-client
      pkgs.whatsapp-for-linux
      pkgs.git
      pkgs.spotify
      pkgs.google-chrome
      pkgs.onlyoffice-bin_7_5
      pkgs.obs-studio
      pkgs.gimp
      pkgs.krita
      pkgs.inkscape
      pkgs.mission-center
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
    (pkgs.writeShellScriptBin "nos" ''
    sudo nixos-rebuild switch
    '')
    (pkgs.writeShellScriptBin "hms" ''
    home-manager switch
    '')
    (pkgs.writeShellScriptBin "server" ''
    ssh -i ~/.ssh/andreas_ubuntu_ws andreas@localhost.onthewifi.com
    '')
  ] ++ extensions;
  
  # required to autoload fonts from packages installed via Home Manager
  fonts.fontconfig.enable = true; 

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".ssh/config".source = ../ssh/config;
    ".config/onlyoffice/DesktopEditors.conf".source = ../onlyoffice/DesktopEditors.conf;
    ".local/share/onlyoffice/desktopeditors/data/settings.xml".source = ../onlyoffice/settings.xml;
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
    # NextCloud client HiDPI support. Doesn't work for autostart.
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };
  
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };
  
  dconf.settings = {
    # Enable installed extensions
    "org/gnome/shell".enabled-extensions = map (extension: extension.extensionUuid) extensions;

    "org/gnome/shell".disabled-extensions = [];
    
    "system/locale" = {
      region = "nl_NL.UTF-8";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      show-battery-percentage = true;
      clock-show-weekday = true;
      font-name = "Ubuntu 11";
      document-font-name = "Ubuntu 11";
      monospace-font-name = "Ubuntu 11";
      font-antialiasing = "rgba";
      text-scaling-factor = 1.1000000000000001;
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${./bg-l.svg}";
      picture-uri-dark = "file://${./bg-d.svg}";
      primary-color = "#241f31";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
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
    "org/gnome/terminal/legacy/profiles:" = {
      list = ["b1dcc9dd-5262-4d8d-a863-c897e6d979b9"];
      default = "b1dcc9dd-5262-4d8d-a863-c897e6d979b9";
    };
    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      visible-name = "Default";
      default-size-columns = 100;
      default-size-rows = 30;
      font = "FiraCode Nerd Font Mono 14";
      use-system-font = false;
      use-theme-colors = false;
      foreground-color = "rgb(255,255,255)";
      background-color = "rgb(43,43,43)";
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      disable-overview-on-startup = true;
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      click-action = "minimize-or-previews";
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
