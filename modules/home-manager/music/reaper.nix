{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.reaper;
in
{
  options.nico.reaper.enable = lib.mkEnableOption "Enable Reaper.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      reaper
      reaper-reapack-extension
    ];
  };
}
