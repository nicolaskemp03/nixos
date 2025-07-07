{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.microsoftoffice;
in
{
  options.nico.microsoftoffice.enable = lib.mkEnableOption "Enable Microsoft Office.";

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = [

    ];
  };
}
