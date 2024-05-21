{ config, inputs, pkgs, lib, ... }:

with lib;

let

cfg = config.shared.programs.direnv;

in
{
  options.shared.programs.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}