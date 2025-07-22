{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.rofi;
  programs.rofi = {
    modes = [
      "drun"
      "run"
      "calc"
      "ssh"
    ];
    terminal = "/home/nico/.nix-profile/bin/fish";
    plugins = with pkgs; [
      rofi-calc
      rofi-games
      rofi-obsidian
    ];
    extraConfig = {
      show-icons = true;
      display-drun = "  apps";
      display-run = "  term";
      display-filebrowser = "  files";
      display-window = "  window";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
      hover-select = true;
      me-select-entry = "MouseSecondary";
      me-accept-entry = "MousePrimary";

    };
  };

in
{
  options.nico.rofi.enable = lib.mkEnableOption "Enable Rofi.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi
    ];
  };

}
