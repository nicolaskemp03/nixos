{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.nico.flatpak;

in
{

  options.nico.flatpak.enable = lib.mkEnableOption "Enable Flatpak, Flathub and Software App";

  config = lib.mkIf cfg.enable {
  };

}
