{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.davinci;
in
{
  options.davinci.enable = lib.mkEnableOption "Enable davinci.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.davinci-resolve-studio
    ];
  };
}
