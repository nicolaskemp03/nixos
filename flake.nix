{
  description = "NixOS config flake file";

  nixConfig = {
    extra-substituters = [ "https://playit-nixos-module.cachix.org" ];
    extra-trusted-public-keys = [
      "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
    ];
  };

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    #nix-flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    #Nixcord
    nixcord = {
      url = "github:kaylorben/nixcord";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    playit-nixos-module = {
      url = "github:pedorich-n/playit-nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-flatpak,
      ...
    }

    @inputs:
    let
      paths = {
        root = "${self}";
        derivations = "${self}/derivations";
        secrets = "${self}/secrets";
        nixos = "${self}/modules/nixos";
        homeManager = "${self}/modules/home-manager";
      };

      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      overlay-module = {
        nixpkgs.overlays = [
          (final: prev: {
            unstable = pkgs-unstable;
          })
        ];
      };

    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              paths
              ;
            pkgs-unstable = pkgs-unstable;
          };
          modules = [
            nix-flatpak.nixosModules.nix-flatpak
            overlay-module
            ./hosts/nixos/configuration.nix
          ];
        };
      };
      homeConfigurations.nico = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Use your main nixpkgs for Home Manager
        extraSpecialArgs = {
          inherit inputs paths pkgs-unstable; # Pass inputs and other useful args
        };
        modules = [

          ./hosts/nixos/home.nix # <--- Your main Home Manager configuration file

        ];
      };
    };
}
