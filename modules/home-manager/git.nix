{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.nico.git;
in
{
  options.nico.git.enable = lib.mkEnableOption "Enable configured git.";

  config = lib.mkIf cfg.enable {

  };
}
