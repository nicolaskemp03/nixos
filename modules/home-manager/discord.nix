{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.discord;
in
{
  options.nico.discord.enable = lib.mkEnableOption "Enable Discord.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (unstable.discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ];
  };
}
