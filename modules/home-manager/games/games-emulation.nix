{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.games.wine-emulation;
in
{
  options.nico.games.wine-emulation.enable = lib.mkEnableOption "Enable Wine Emulation.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs.unstable; [
      lutris
      heroic
      wine
      winetricks
    ];
    programs.lutris.winePackages = "
     [pkgs.wineWowPackages.waylandFull
    ]";
  };
}
