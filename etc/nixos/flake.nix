{
  description = "NixOS configuration of andreas";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    # For command-not-found
    programsdb.url = "github:wamserma/flake-programs-sqlite";
    programsdb.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.xps = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos-modules/flake-programs-sqlite.nix
        ./configuration.nix
      ];
      specialArgs = { inherit inputs; };
    };
  };
}