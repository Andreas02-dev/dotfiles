{
  config
, pkgs
, inputs
, ...
}: 
  let
    # Previously /etc/nixPath, but some tools
    # (f.e. VS Code extension rust-analyzer)
    # Ignore /etc/ paths
    nixPath = "/nix/var/nix/nixPath/nixpkgs"; 
  in {
    systemd.tmpfiles.rules = [
      "d /nix/var/nix/nixPath 0755 root root -"
      "L+ ${nixPath} - - - - ${pkgs.path}"
    ];

    nix.nixPath = [
      "nixpkgs=${nixPath}"
    ];
}