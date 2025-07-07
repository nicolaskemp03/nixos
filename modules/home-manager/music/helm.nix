{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.helm;
in
{
  options.nico.helm.enable = lib.mkEnableOption "Enable Helm.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.helm
    ];
  };
}
