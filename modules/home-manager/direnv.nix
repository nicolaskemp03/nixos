{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.direnv;
in
{

  options.nico.direnv.enable = lib.mkEnableOption "Enable Direnv.";

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
