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

  options.nico.discord.enable = lib.mkEnableOption "Enable Discord.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      #vesktop
    ];
    programs.nixcord = {
      enable = true;
      discord.enable = true;
      #vesktop.enable = true;
    };
  };
}
