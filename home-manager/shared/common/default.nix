{
  inputs,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    # Required to autoload fonts from packages installed via Home Manager
    fonts.fontconfig.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
