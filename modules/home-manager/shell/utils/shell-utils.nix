{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nico.shell-utils;
in
{
  imports = [
    ./btop.nix
    ./eza.nix
    ./tldr.nix
    ./zoxide.nix
  ];

  options.nico.shell-utils = {
    enable = lib.mkEnableOption "Enable nico's shell utils.";
  };

  config = lib.mkIf cfg.enable {
    #nico.btop.enable = lib.mkDefault true;
    nico.eza.enable = lib.mkDefault true;
    nico.tldr.enable = lib.mkDefault true;
    nico.zoxide.enable = lib.mkDefault true;

    programs.bat.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      dust
      ripgrep
    ];
  };
}
