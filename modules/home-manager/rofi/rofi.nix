{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.rofi;

in
{
  options.nico.rofi.enable = lib.mkEnableOption "Enable Rofi.";

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      theme = "/home/nico/nixos-config/modules/home-manager/rofi/rounded-nord-dark.rasi";
      #configPath = "/home/nico/nixos-config/modules/home-manager/rofi/config.rasi";
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
        display-calc = "+math";
        drun-display-format = "{name}";
        window-format = "{w} · {c} · {t}";
        hover-select = true;
        me-select-entry = "MouseSecondary";
        me-accept-entry = "MousePrimary";
        normal-window = true;
      };
    };
  };

}
