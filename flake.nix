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

    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    playit-nixos-module = {
      url = "github:pedorich-n/playit-nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-flatpak,
      playit-nixos-module,
      agenix,
      stylix,
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
            vscode-marketplace = inputs.nix-vscode-extensions.extensions.${prev.system}.vscode-marketplace;
          })
        ];
      };

    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              paths
              home-manager
              agenix
              ;
            pkgs-unstable = pkgs-unstable;
          };
          modules = [
            stylix.nixosModules.stylix
            nix-flatpak.nixosModules.nix-flatpak
            overlay-module
            playit-nixos-module.nixosModules.default
            agenix.nixosModules.default
            ./hosts/nixos/configuration.nix
            {
              environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
            }
          ];
        };
      };
      homeConfigurations.nico = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              unstable = pkgs-unstable;
              vscode-marketplace = inputs.nix-vscode-extensions.extensions.${prev.system}.vscode-marketplace;
            })
          ];
        };
        extraSpecialArgs = {
          inherit
            inputs
            paths
            pkgs-unstable
            home-manager
            ; # Pass inputs and other useful args
        };
        modules = [
          ./hosts/nixos/home.nix # <--- Your main Home Manager configuration file

        ];
      };
    };
}
