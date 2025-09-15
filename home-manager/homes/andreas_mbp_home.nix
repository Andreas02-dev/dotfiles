{
  config,
  pkgs,
  upkgs,
  system,
  lib,
  inputs,
  ...
}:

{
  home.username = "Andreas.Hoornstra";
  home.homeDirectory = "/Users/Andreas.Hoornstra";

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

  programs.zsh.enable = true;
  programs.git.enable = true;

  home.packages = with pkgs; [ 
    openssh
    libfido2
    yubikey-manager
   ];

  programs.ssh.enable = true;
  programs.ssh.extraConfig = ''
    Host *
      SecurityKeyProvider ${pkgs.libfido2}/lib/libfido2.dylib
  '';

  programs.firefox.enable = true;

  # Ensure HM can manage itself
  programs.home-manager.enable = true;
}
