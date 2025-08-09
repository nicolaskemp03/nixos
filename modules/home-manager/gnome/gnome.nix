{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.gnome;
in
{

  options.nico.gnome.enable = lib.mkEnableOption "Enable GNOME config.";

  config = lib.mkIf cfg.enable {

  };
}
