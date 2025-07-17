{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.flatpak;
  #pythonFull = pkgs.python3.withPackages (_: [ ]);
  #raysessionFixed = pkgs.raysession.overrideAttrs (oldAttrs: {
  #python311 = pythonFull;
  #});
in
{
  options.nico.flatpak.enable = lib.mkEnableOption "Enable Flatpak.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      flatpak
      gnome-software
    ];
  };

}
