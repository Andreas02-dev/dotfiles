{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.shared.programs.starship;
in {
  options.shared.programs.starship = {
    enable = mkEnableOption "starship";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = lib.importTOML ./starship.toml;
    };
  };
}
