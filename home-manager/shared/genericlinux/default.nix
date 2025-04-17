{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.shared.genericlinux;
in {
  options.shared.genericlinux = {
    enable = mkEnableOption "genericlinux";
  };

  config = mkIf cfg.enable {
    # Add command-not-found without using channels
    programs.command-not-found.dbPath = inputs.programsdb.packages.${pkgs.system}.programs-sqlite;

    # Fix desktop entries not showing up in Gnome
    targets.genericLinux.enable = true;
    xdg.mime.enable = true;
    xdg.systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];
  };
}
