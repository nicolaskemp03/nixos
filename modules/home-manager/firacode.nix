{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.firacode;
in
{
  options.nico.firacode.enable = lib.mkEnableOption "Enable FiraCode.";

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      pkgs.nerd-fonts.fira-code
    ];
  };
}
