{
  config,
  pkgs,
  lib,
  agenix,
  ...
}:
let

  cfg = config.nico.games;

  protonhax = pkgs.stdenv.mkDerivation {
    pname = "protonhax";
    version = "2024-08-19"; # Use a date or version
    src = pkgs.fetchFromGitHub {
      owner = "jcnils";
      repo = "protonhax";
      rev = "922a7bbade5a93232b3152cc20a7d8422db09c31"; # Replace with the latest commit hash from the GitHub repo
      sha256 = "sha256-P6DVRz8YUF4JY2tiEVZx16FtK4i/rirRdKKZBslbJxU"; # Replace with the correct SHA256 hash
    };
    unpackPhase = "true";
    installPhase = ''
      install -D $src/protonhax $out/bin/protonhax
    '';
    buildInputs = [ pkgs.bash ];
  };

in
{
  options.nico.games.enable = lib.mkEnableOption "Enable Game Software.";

  imports = [
    agenix.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      protontricks
      mangohud
      unstable.alvr
      unstable.wlx-overlay-s
      wineWowPackages.stable
      winetricks
      wine-staging
      dxvk
      vkd3d-proton
      unstable.heroic
      lutris
      prismlauncher
      temurin-jre-bin

      #Emulation
      cemu
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extest.enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

  };
}
