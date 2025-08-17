{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.games;
in
{
  options.nico.games.enable = lib.mkEnableOption "Enable Game Software.";

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
