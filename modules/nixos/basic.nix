{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.nico.basic;
in
{
  options.nico.basic.enable = lib.mkEnableOption "Enable Basic software like browsers or discord";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      ente-auth
      ente-cli
      bitwarden-cli
    ];

  };
}
