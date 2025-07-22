{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.rofi;
in
{
  options.nico.rofi.enable = lib.mkEnableOption "Enable Rofi.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi
    ];
  };
}
