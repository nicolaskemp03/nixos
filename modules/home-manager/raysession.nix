{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.raysession;
  #pythonFull = pkgs.python3.withPackages (_: [ ]);
  #raysessionFixed = pkgs.raysession.overrideAttrs (oldAttrs: {
  #python311 = pythonFull;
  #});
in
{
  options.nico.raysession.enable = lib.mkEnableOption "Enable Raysession.";

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      easyeffects
      raysession
      python313Packages.legacy-cgi
    ];
    #programs.command-not-found.enable = true;
    services.easyeffects.enable = true;
  };
}
