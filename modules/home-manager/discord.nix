{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.nico.discord;
in
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  options.nico.discord.enable = lib.mkEnableOption "Enable Discord.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vesktop
    ];

  };
}
