{ config, pkgs, lib, ... }:
let
unstable = import <nixos-unstable> {};
extensions = with pkgs.gnomeExtensions; [
  dash-to-dock
  caffeine
  appindicator
  just-perfection
  blur-my-shell
] ++ ( with unstable.pkgs.gnomeExtensions; [
  resource-monitor
] );
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
  home.packages = with pkgs; [
      firefox
      fastfetch
      discord
      ubuntu_font_family
      fira-code-nerdfont
      fira-mono
      gnome.gnome-terminal
      direnv
      nix-index
      gnome.zenity
      nextcloud-client
      whatsapp-for-linux
      git
      spotify
      google-chrome
      onlyoffice-bin_7_5
      obs-studio
      gimp
      krita
      inkscape
      mission-center
      zotero
      dell-command-configure
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
    (pkgs.writeShellScriptBin "nos" ''
    sudo nixos-rebuild switch
    '')
    (pkgs.writeShellScriptBin "hms" ''
    home-manager switch
    '')
    (pkgs.writeShellScriptBin "server" ''
    ssh -i ~/.ssh/andreas_ubuntu_ws andreas@localhost.onthewifi.com
    '')
    (pkgs.writeShellScriptBin "battnormal" ''
    sudo cctk --PrimaryBattChargeCfg=Standard
    '')
    (pkgs.writeShellScriptBin "battexpress" ''
    sudo cctk --PrimaryBattChargeCfg=Express
    '')
    (pkgs.writeShellScriptBin "battcustom" ''
    sudo cctk --PrimaryBattChargeCfg=Custom:50-80
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
  
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
    [
      usernamehw.errorlens
      tamasfe.even-better-toml
      ms-dotnettools.csharp
      vadimcn.vscode-lldb
      serayuzgur.crates
      dart-code.dart-code
      dart-code.flutter
      skellock.just
      vscjava.vscode-maven
      ms-python.python
      rust-lang.rust-analyzer
      jnoortheen.nix-ide
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "dotnet-test-explorer";
        publisher = "formulahendry";
        version = "0.7.8";
        sha256 = "qI+mPFotFBnaTUwWOcWfa4zUzyAvSjehIwLCuoK+sQE=";
      }
      {
        name = "arb-editor";
        publisher = "Google";
        version = "0.0.12";
        sha256 = "1egXFSDBe2njR4gI3mr+2Hu5TddP2VHkxjdgwCwXXU4=";
      }
      {
        name = "csharpier-vscode";
        publisher = "csharpier";
        version = "1.5.2";
        sha256 = "A2AGcUF1SQuSPECghArBxx/gi5JiIk7o6wzfgCPcfgI=";
      }
    ];
    userSettings = {
      "workbench.colorTheme" = "Default High Contrast";
      "window.zoomLevel" = 1;
  "redhat.telemetry.enabled" = false;
  "editor.fontFamily" = "Firacode Nerd Font Mono";
  "terminal.integrated.fontFamily" = "Firacode Nerd Font Mono";
  "[rust]" = {
    "editor.formatOnSave" = true;
    "editor.formatOnType" = true;
    "editor.defaultFormatter" = "rust-lang.rust-analyzer";
  };
  "[dart]" = {
    "editor.formatOnSave" = true;
    "editor.formatOnType" = true;
    "editor.selectionHighlight" = false;
    "editor.suggest.snippetsPreventQuickSuggestions" = false;
    "editor.suggestSelection" = "first";
    "editor.tabCompletion" = "onlySnippets";
    "editor.wordBasedSuggestions" = "off";
  };
  "terminal.integrated.defaultProfile.linux" = "fish";
  "docker.composeCommand" = "docker compose";
  "docker.dockerPath" = "/usr/bin/docker";
  "diffEditor.codeLens" = true;
  "dev.containers.dockerComposePath" = "docker compose";
  "tailwindCSS.includeLanguages" = {
    "razor" = "html";
  };
  "diffEditor.ignoreTrimWhitespace" = false;
  "errorLens.excludeBySource" = [
    "dart(missing_identifier)"
  ];
    };
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
  
  dconf.settings = let inherit (lib.hm.gvariant) mkTuple mkUint32 mkVariant mkDictionaryEntry mkDouble; in {
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
      click-action = "minimize-or-previews";
      dash-max-icon-size = 52;
    };
    "com/github/Ory0n/Resource_Monitor" = {
      diskstatsstatus = false;
      diskspacestatus = false;
      netethstatus = false;
      netwlanstatus = false;
      cpustatus = true;
      ramstatus = true;
      thermalcputemperaturestatus = true;
      thermalcputemperaturedeviceslist = [
        "coretemp: Core 20-false-/sys/class/hwmon/hwmon3/temp10_input"
        "coretemp: Core 21-false-/sys/class/hwmon/hwmon3/temp11_input"
        "coretemp: Core 22-false-/sys/class/hwmon/hwmon3/temp12_input"
        "coretemp: Core 23-false-/sys/class/hwmon/hwmon3/temp13_input"
        "coretemp: Package id 0-true-/sys/class/hwmon/hwmon3/temp1_input"
        "coretemp: Core 0-false-/sys/class/hwmon/hwmon3/temp2_input"
        "coretemp: Core 4-false-/sys/class/hwmon/hwmon3/temp3_input"
        "coretemp: Core 8-false-/sys/class/hwmon/hwmon3/temp4_input"
        "coretemp: Core 12-false-/sys/class/hwmon/hwmon3/temp5_input"
        "coretemp: Core 16-false-/sys/class/hwmon/hwmon3/temp6_input"
        "coretemp: Core 17-false-/sys/class/hwmon/hwmon3/temp7_input"
        "coretemp: Core 18-false-/sys/class/hwmon/hwmon3/temp8_input"
        "coretemp: Core 19-false-/sys/class/hwmon/hwmon3/temp9_input"
      ];
    };
    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      startup-status = 0; # Desktop
    };
  # Utrecht and Beijing clocks for Gnome Shell
  "org/gnome/shell/world-clocks" = {
    locations = [
      (mkVariant (mkTuple [
        (mkUint32 2)
        (mkVariant (mkTuple [
          "Utrecht"
          "EHAM"
          true
          [(mkTuple [ (mkDouble "0.91280719879303418") (mkDouble "0.083194033496160544") ])]
          [(mkTuple [ (mkDouble "0.90914200736384632") (mkDouble "0.089360857702109678") ])]
        ]))
      ]))
      (mkVariant (mkTuple [
        (mkUint32 2)
        (mkVariant (mkTuple [
          "Beijing"
          "ZBAA"
          true
          [(mkTuple [ (mkDouble "0.69696814214530467") (mkDouble "2.0295270260429752") ])]
          [(mkTuple [ (mkDouble "0.69689057971334611") (mkDouble "2.0313596217575696") ])]
        ]))
      ]))              
    ];
  };
  # Utrecht and Beijing clocks for clocks app
  "org/gnome/clocks" = {
    world-clocks = [
      [(mkDictionaryEntry["location" (mkVariant (mkTuple [
        (mkUint32 2)
        (mkVariant (mkTuple [
          "Utrecht"
          "EHAM"
          true
          [(mkTuple [ (mkDouble "0.91280719879303418") (mkDouble "0.083194033496160544") ])]
          [(mkTuple [ (mkDouble "0.90914200736384632") (mkDouble "0.089360857702109678") ])]
        ]))
        ]))])]
      [(mkDictionaryEntry["location" (mkVariant (mkTuple [
        (mkUint32 2)
        (mkVariant (mkTuple [
          "Beijing"
          "ZBAA"
          true
          [(mkTuple [ (mkDouble "0.69696814214530467") (mkDouble "2.0295270260429752") ])]
          [(mkTuple [ (mkDouble "0.69689057971334611") (mkDouble "2.0313596217575696") ])]
        ]))
        ]))])]
    ];
  };
  # Utrecht weather for GNOME Shell
  "org/gnome/shell/weather"  = {
    automatic-location = true;
    locations = [ (mkVariant (mkTuple [
              (mkUint32 2)
              (mkVariant (mkTuple [
                "Utrecht"
                "EHAM"
                true
                [ (mkTuple [ (0.91280719879303418) (0.083194033496160544) ]) ]
                [ (mkTuple [ (0.90914200736384632) (0.089360857702109678) ]) ]
              ]))
            ])) ];
    };
  # Utrecht weather for weather app
  "org/gnome/Weather"  = {
      locations = [ (mkVariant (mkTuple [
                (mkUint32 2)
                (mkVariant (mkTuple [
                  "Utrecht"
                  "EHAM"
                  true
                  [ (mkTuple [ (0.91280719879303418) (0.083194033496160544) ]) ]
                  [ (mkTuple [ (0.90914200736384632) (0.089360857702109678) ]) ]
                ]))
              ])) ];
    };
    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      style-dialogs = 3;
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
