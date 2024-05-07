{config, pkgs, inputs, ...}:
{
  _module.args.upkgs = import inputs.nixpkgs-unstable {
    inherit (config.nixpkgs) config overlays;
    localSystem = pkgs.stdenv.hostPlatform;
  };
}