{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.wine;
in
{
  options.nico.wine.enable = lib.mkEnableOption "Enable Game Software.";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wineWowPackages.full
      winetricks
      wine-staging
      dxvk
      vkd3d-proton
    ];
  };
}
