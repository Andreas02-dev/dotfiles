{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.shared.ssh_config;
in {
  options.shared.ssh_config = {
    enable = mkEnableOption "ssh_config";
  };

  config = mkIf cfg.enable {
    home.file.".ssh/config" = {
      text = ''
        #private account
        Host private
                HostName github.com
                User git
                IdentityFile ~/.ssh/id_rsa_private

        #school account
        Host school
                HostName github.com
                User git
                IdentityFile ~/.ssh/id_rsa_school

        #igne account
        Host igne
                HostName bitbucket.org
                User git
                IdentityFile ~/.ssh/id_rsa_school
      '';
      target = ".ssh/config_source";
      onChange = "cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config";
    };
  };
}
