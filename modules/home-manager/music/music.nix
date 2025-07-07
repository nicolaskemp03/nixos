{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.nico.music;
  musicModules = "${inputs.self}/modules/home-manager/music";
in
{
  imports = [
    "${musicModules}/reaper.nix"
    "${musicModules}/helm.nix"
    "${musicModules}/yabridge.nix"
  ];

  options.nico.music.enable = lib.mkEnableOption "Enable all of my music production configuration.";

  config = lib.mkIf cfg.enable {
    nico.reaper.enable = true;
    nico.helm.enable = true;
    nico.yabridge.enable = true;
  };
}
