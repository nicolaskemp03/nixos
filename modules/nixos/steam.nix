{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.steam;
in
{
  options.nico.steam.enable = lib.mkEnableOption "Enable Game Software.";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      protontricks
      mangohud
      unstable.alvr
      unstable.wlx-overlay-s
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

  };
}
