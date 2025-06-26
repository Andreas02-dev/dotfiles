{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.shared.programs.fish;
in {
  options.shared.programs.fish = {
    enable = mkEnableOption "fish";
    isNixOS = mkOption {
      type = types.bool;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.isNixOS {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting # Disable greeting
        '';
      };
    })
    (mkIf (!cfg.isNixOS) {
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
      home.file.".config/fish/completions/nix.fish".source = "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";
    })
  ]);
}
