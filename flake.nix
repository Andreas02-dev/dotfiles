{
  description = "Nix configuration of Andreas";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    ## NixOS
    ## -----------------------

    # For command-not-found
    programsdb.url = "github:wamserma/flake-programs-sqlite";
    programsdb.inputs.nixpkgs.follows = "nixpkgs";

    ## -----------------------

    ## NixOS WSL
    ## -----------------------
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    ## -----------------------

    ## Home-manager
    ## -----------------------

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";

    ## -----------------------

    ## NixGL
    ## -----------------------

    nixgl.url = "github:nix-community/nixGL";

    ## -----------------------

    ## System-manager
    ## -----------------------

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## -----------------------

    ## chromium-109
    ## -----------------------

    chromium-109 = {
      url = "github:nixos/nixpkgs/3c3b3ab88a34ff8026fc69cb78febb9ec9aedb16";
    };

    ## -----------------------

  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixgl,
    system-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      xps = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./etc/nixos/nixos-modules/upkgs.nix
          ./etc/nixos/nixos-modules/nh.nix
          ./etc/nixos/nixos-modules/flake-programs-sqlite.nix
          ./etc/nixos/hosts/xps/xps_configuration.nix
        ];
      };
      ldhnieuwegein = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./etc/nixos/nixos-modules/upkgs.nix
          ./etc/nixos/nixos-modules/nh.nix
          ./etc/nixos/nixos-modules/flake-programs-sqlite.nix
          ./etc/nixos/hosts/ldhnieuwegein/ldhnieuwegein_configuration.nix
        ];
      };
      server = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./etc/nixos/nixos-modules/upkgs.nix
          ./etc/nixos/nixos-modules/nh.nix
          ./etc/nixos/nixos-modules/flake-programs-sqlite.nix
          ./etc/nixos/hosts/server/server_configuration.nix
        ];
      };
      # Work WSL Dell
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          inputs.nixos-wsl.nixosModules.wsl
          ./etc/nixos/nixos-modules/upkgs.nix
          ./etc/nixos/nixos-modules/nh.nix
          ./etc/nixos/nixos-modules/flake-programs-sqlite.nix
          ./etc/nixos/hosts/nixos/nixos_configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # Dell XPS 13 Plus 9320 (NixOS 23.11 Tapir)
      "andreas@xps" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home-modules/upkgs.nix
          ./home-manager/homes/andreas_xps_home.nix
        ];
      };

      # HP ProDesk 400 G2.5 SFF (Ubuntu 22.04 LTS)
      "andreas@hp" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home-modules/upkgs.nix
          ./home-manager/homes/andreas_hp_home.nix
        ];
      };

      # Steam Deck OLED 1TB (SteamOS 3.5)
      "deck@steamdeck" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home-modules/upkgs.nix
          ./home-manager/homes/deck_steamdeck_home.nix
        ];
      };

      # Presentation-PC: AMD Ryzen 5 3600 + NVIDIA Quadro P620 2GB
      "ldh@ldhnieuwegein" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home-modules/upkgs.nix
          ./home-manager/homes/ldh_ldhnieuwegein_home/ldh_ldhnieuwegein_home.nix
        ];
      };

      # Server
      "andreas@server" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home-modules/upkgs.nix
          ./home-manager/homes/andreas_server_home.nix
        ];
      };
      # Dell Latitude 5550 (Win11 WSL)
      "nixos@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home-modules/upkgs.nix
          ./home-manager/homes/nixos_nixos_home.nix
        ];
      };
    };

    systemConfigs = {
      # Steam Deck OLED 1TB (SteamOS 3.5)
      steamdeck = system-manager.lib.makeSystemConfig {
        modules = [
          ./system-manager/systems/steamdeck
        ];
      };
    };
  };
}
