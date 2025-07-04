{
  config,
  pkgs,
  upkgs,
  system,
  lib,
  inputs,
  ...
}: let
  extensions = with pkgs.gnomeExtensions;
    [
      dash-to-dock
      caffeine
      appindicator
      just-perfection
      blur-my-shell
    ]
    ++ (with upkgs.gnomeExtensions; [
      resource-monitor
    ]);
in {
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
  home.packages = with pkgs;
    [
      (firefox.override {nativeMessagingHosts = [inputs.pipewire-screenaudio.packages.${pkgs.system}.default];})
      fastfetch
      ubuntu_font_family
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      gnome-terminal
      zenity
      nextcloud-client
      whatsapp-for-linux
      git
      spotify
      google-chrome
      onlyoffice-bin_latest
      gimp
      krita
      inkscape
      mission-center
      zotero
      dell-command-configure
      screen
      handbrake
      subtitleedit
      quickemu
      quickgui
      qbittorrent
      vesktop
      protonvpn-gui
      parabolic
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
      (pkgs.writeShellScriptBin "balanced" ''
        sudo cctk --ThermalManagement=Optimized
      '')
      (pkgs.writeShellScriptBin "performance" ''
        sudo cctk --ThermalManagement=UltraPerformance
      '')
    ]
    ++ (with upkgs; [
      ffmpeg
      vscode-fhs
    ])
    ++ extensions;

  shared.ssh_config.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/onlyoffice/DesktopEditors.conf".text = ''
      [General]
      UITheme=theme-dark
      editorWindowMode=false
      titlebar=custom

    '';
    ".local/share/onlyoffice/desktopeditors/data/settings.xml".text = ''
      <Settings><force-scale>0</force-scale><system-scale>0</system-scale></Settings>
    '';
    ".config/easyeffects/input/mic_preset.json".source = ../easyeffects/input/mic_preset.json;
    ".config/easyeffects/output/bass_enhancing_perfect_eq.json".source = ../easyeffects/output/bass_enhancing_perfect_eq.json;
    ".config/easyeffects/autoload/input/alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_4__source:[In] Mic.json".source = ../easyeffects/autoload/input/input.json;
    # Doesn't work, using `systemd.user.services.easyeffects.Service.ExecStartPost` as workaround (https://github.com/nix-community/home-manager/issues/5185)
    ".config/easyeffects/autoload/output/alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_2__sink:[Out] Speaker.json".source = ../easyeffects/autoload/output/output.json;
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
    NH_FLAKE = "/home/andreas/config";
    # EDITOR = "emacs";
  };

  shared.programs.direnv.enable = true;
  shared.programs.fish = {
    enable = true;
    isNixOS = true;
  };
  shared.programs.starship.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  services.easyeffects = {
    enable = true;
    # Doesn't work, using `systemd.user.services.easyeffects.Service.ExecStartPost` as workaround (https://github.com/nix-community/home-manager/issues/5185)
    preset = "bass_enhancing_perfect_eq";
  };

  systemd.user.services.easyeffects.Service.ExecStartPost = [
    "${config.services.easyeffects.package}/bin/easyeffects --load-preset ${config.services.easyeffects.preset}"
  ];

  dconf.settings = let
    inherit (lib.hm.gvariant) mkTuple mkUint32 mkVariant mkDictionaryEntry mkDouble;
  in {
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
      picture-uri = "file://${../bg-l.svg}";
      picture-uri-dark = "file://${../bg-d.svg}";
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
      custom-font = "FiraMono Nerd Font Mono 14";
    };
    "org/gnome/TextEditor" = {
      use-system-font = false;
      custom-font = "FiraMono Mono 14";
    };
    "org/gnome/terminal/legacy/profiles:" = {
      list = ["b1dcc9dd-5262-4d8d-a863-c897e6d979b9"];
      default = "b1dcc9dd-5262-4d8d-a863-c897e6d979b9";
    };
    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      visible-name = "Default";
      default-size-columns = 100;
      default-size-rows = 30;
      font = "FiraMono Nerd Font Mono 14";
      use-system-font = false;
      use-theme-colors = false;
      foreground-color = "rgb(255,255,255)";
      background-color = "rgb(43,43,43)";
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      disable-overview-on-startup = true;
      click-action = "minimize-or-previews";
      dash-max-icon-size = 52;
      running-indicator-style = "DOTS";
      custom-background-color = true;
      background-color = "rgb(53,53,53)";
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
            [(mkTuple [(mkDouble "0.91280719879303418") (mkDouble "0.083194033496160544")])]
            [(mkTuple [(mkDouble "0.90914200736384632") (mkDouble "0.089360857702109678")])]
          ]))
        ]))
        (mkVariant (mkTuple [
          (mkUint32 2)
          (mkVariant (mkTuple [
            "Beijing"
            "ZBAA"
            true
            [(mkTuple [(mkDouble "0.69696814214530467") (mkDouble "2.0295270260429752")])]
            [(mkTuple [(mkDouble "0.69689057971334611") (mkDouble "2.0313596217575696")])]
          ]))
        ]))
      ];
    };
    # Utrecht and Beijing clocks for clocks app
    "org/gnome/clocks" = {
      world-clocks = [
        [
          (mkDictionaryEntry [
            "location"
            (mkVariant (mkTuple [
              (mkUint32 2)
              (mkVariant (mkTuple [
                "Utrecht"
                "EHAM"
                true
                [(mkTuple [(mkDouble "0.91280719879303418") (mkDouble "0.083194033496160544")])]
                [(mkTuple [(mkDouble "0.90914200736384632") (mkDouble "0.089360857702109678")])]
              ]))
            ]))
          ])
        ]
        [
          (mkDictionaryEntry [
            "location"
            (mkVariant (mkTuple [
              (mkUint32 2)
              (mkVariant (mkTuple [
                "Beijing"
                "ZBAA"
                true
                [(mkTuple [(mkDouble "0.69696814214530467") (mkDouble "2.0295270260429752")])]
                [(mkTuple [(mkDouble "0.69689057971334611") (mkDouble "2.0313596217575696")])]
              ]))
            ]))
          ])
        ]
      ];
    };
    # Utrecht weather for GNOME Shell
    "org/gnome/shell/weather" = {
      automatic-location = true;
      locations = [
        (mkVariant (mkTuple [
          (mkUint32 2)
          (mkVariant (mkTuple [
            "Utrecht"
            "EHAM"
            true
            [(mkTuple [0.91280719879303418 0.083194033496160544])]
            [(mkTuple [0.90914200736384632 0.089360857702109678])]
          ]))
        ]))
      ];
    };
    # Utrecht weather for weather app
    "org/gnome/Weather" = {
      locations = [
        (mkVariant (mkTuple [
          (mkUint32 2)
          (mkVariant (mkTuple [
            "Utrecht"
            "EHAM"
            true
            [(mkTuple [0.91280719879303418 0.083194033496160544])]
            [(mkTuple [0.90914200736384632 0.089360857702109678])]
          ]))
        ]))
      ];
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
    "com/github/wwmm/easyeffects" = {
      process-all-outputs = true;
      process-all-inputs = true;
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
