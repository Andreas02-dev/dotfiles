# Use NixOS module until HM module is available: https://github.com/nix-community/home-manager/pull/5304
{
  pkgs,
  inputs,
  upkgs,
  ...
}: {
  
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.dates = "daily";
    clean.extraArgs = "--keep-since 4d --keep 3";
  };
}
