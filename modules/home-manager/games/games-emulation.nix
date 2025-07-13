{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.games.emulation;
in
{
  options.nico.games.emulation.enable = lib.mkEnableOption "Enable Game Emulation.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lutris
      heroic
    ];
    programs.lutris.winePackages = "
     [pkgs.wineWowPackages.waylandFull
    ]";
  };
}
