{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

let

  cfg = config.nico.dev;

in
{

  options.nico.dev.enable = lib.mkEnableOption "Enable productivity and gestion applications";

  config = lib.mkIf cfg.enable {

  };
}
