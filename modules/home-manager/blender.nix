{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.blender;
in
{
  options.nico.blender.enable = lib.mkEnableOption "Enable Blender.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.blender-hip
      pkgs.ffmpeg_7
    ];
  };
}
