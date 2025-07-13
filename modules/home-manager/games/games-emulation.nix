{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.blender;
in
{
  options.nico.blender.enable = lib.mkEnableOption "Enable Blender.";

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
