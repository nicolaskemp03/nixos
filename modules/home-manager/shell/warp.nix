{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  cfg = config.nico.warp-terminal;
in
{
  options.nico.warp-terminal.enable = lib.mkEnableOption "Enable Warp Terminal.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      unstable.warp-terminal
    ];
  };
}
