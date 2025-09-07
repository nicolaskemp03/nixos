{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nico.kitty;

in
{

  options.nico.kitty.enable = lib.mkEnableOption "Enable Kitty.";

  config = lib.mkIf cfg.enable {

  };
}
