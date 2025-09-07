# Don't forget to add
# environment.pathsToLink = [ "/share/zsh" ];
# to the system configuration.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nico.fish;
in
{
  options.nico.fish = {
    enable = lib.mkEnableOption "Enable nico's fish.";
  };

  config = lib.mkIf cfg.enable {

  };
}
