{
  config,
  pkgs,
  lib,
  paths,
  ...
}:
let
  cfg = config.nico.yabridge;
in
{
  options.nico.yabridge.enable = lib.mkEnableOption "Enable yabridge.";

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      yabridge
      wineWowPackages.yabridge
      yabridgectl
      winetricks
    ];

    home.sessionVariables."W_NO_WIN64_WARNINGS" = "1";
  };
}
