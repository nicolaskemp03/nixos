{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nico.theme;
in
{
  options.nico.theme.enable = lib.mkEnableOption "Enable Stylix";

  config = lib.mkIf cfg.enable {

    stylix.enable = false;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";

  };
}
