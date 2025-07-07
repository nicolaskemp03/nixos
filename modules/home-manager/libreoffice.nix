{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.libreoffice;
in
{
  options.nico.libreoffice.enable = lib.mkEnableOption "Enable LibreOffice.";

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = [
      pkgs.cabin
      pkgs.libreoffice-qt
    ];
  };
}
