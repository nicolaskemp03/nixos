{
  description = "NixOS config flake file";

  nixConfig = {
    extra-substituters = [ "https://playit-nixos-module.cachix.org" ];
    extra-trusted-public-keys = [
      "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
    ];
  };

  inputs = {
    #mrshmllow solution for affinity runing on linux
    affinity-nix.url = "github:mrshmllow/affinity-nix";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    affinity-nix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
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
      affinity-nix,
      home-manager,
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
            overlay-module
            ./hosts/nixos/configuration.nix
          ];
        };
      };
      homeConfigurations.nico = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Use your main nixpkgs for Home Manager
        extraSpecialArgs = {
          inherit inputs paths pkgs-unstable; # Pass inputs and other useful args
          # You might not need to pass pkgs-unstable if it's only used in NixOS config,
          # but passing 'inputs' is key for affinity-nix.
        };
        modules = [
          ./hosts/nixos/home.nix # <--- Your main Home Manager configuration file
          # Add other top-level Home Manager modules here if you have any.
          # The individual affinity app enabling will go inside home.nix or a module imported by it.
        ];
      };
    };
}
