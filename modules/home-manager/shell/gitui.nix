# shamelessly stolen from
# https://github.com/NixOS/nixpkgs/blob/0ef7eac2171048c8a4853a195cc1f9123b4906d6/pkgs/data/themes/catppuccin/default.nix
{
  pkgs,
  lib,
  config,
  ...
}:
let
  catpuccin-gitui = pkgs.fetchFromGitHub {
    name = "gitui";
    owner = "catppuccin";
    repo = "gitui";
    rev = "c7661f043cb6773a1fc96c336738c6399de3e617";
    hash = "sha256-CRxpEDShQcCEYtSXwLV5zFB8u0HVcudNcMruPyrnSEk=";
  };
  cfg = config.nico.gitui;
in
{
  options.nico.gitui = {
    enable = lib.mkEnableOption "Enable nico's gitui.";
    theme = lib.mkOption {
      type = lib.types.enum [
        "frappe"
        "latte"
        "macchiato"
        "mocha"
      ];
      default = "mocha";
      example = "frappe";
      description = "Which of the Catppuccin themes to use";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gitui = {
      enable = true;
      theme = lib.readFile "${catpuccin-gitui}/themes/catppuccin-${cfg.theme}.ron";
    };
  };
}
