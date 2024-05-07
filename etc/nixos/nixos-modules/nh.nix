# Use NixOS module until HM module is available: https://github.com/nix-community/home-manager/pull/5304

{
  pkgs
  , inputs
  , upkgs
  , ...
}: {
  # first we need to disable the service module coming from nixpkgs
  # the path we give here is relative to the nixos/modules/ dir
  disabledModules = [
    "programs/nh.nix"
  ];

  # then we add an import of the same module from nixpkgs-unstable
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/programs/nh.nix"
  ];
  
  # now this service definition block refers to the module as defined in
  # inputs.nixos-unstable
  programs.nh = {
    enable = true;
    package = upkgs.nh;
    clean.enable = true;
    clean.dates = "daily";
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

}