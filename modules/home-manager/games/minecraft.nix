{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nico.games.minecraft;
in
{
  options.nico.games.minecraft.enable = lib.mkEnableOption "Enable Minecraft.";

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      prismlauncher
      temurin-jre-bin
    ];

  };
}
