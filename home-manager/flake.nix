{
  description = "Home Manager configuration of andreas";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      nixpkgsConfig = {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations."andreas" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          nixpkgs = {
            from = {
              stable = import nixpkgs nixpkgsConfig;
              unstable = import nixpkgs-unstable nixpkgsConfig;
            };
          };
        };
      };
    };
}
