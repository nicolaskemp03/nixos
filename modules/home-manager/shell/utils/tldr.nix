{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.tldr;
in
{
  options.nico.tldr.enable = lib.mkEnableOption "Enable Vesktop.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tldr
    ];
  };
}
