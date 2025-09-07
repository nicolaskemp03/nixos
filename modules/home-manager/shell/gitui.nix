# shamelessly stolen from
# https://github.com/NixOS/nixpkgs/blob/0ef7eac2171048c8a4853a195cc1f9123b4906d6/pkgs/data/themes/catppuccin/default.nix
{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nico.gitui;
in
{
  options.nico.gitui = {
    enable = lib.mkEnableOption "Enable nico's gitui.";
  };

  config = lib.mkIf cfg.enable {

  };
}
