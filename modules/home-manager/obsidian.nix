{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nico.obsidian;
in
{
  options.nico.obsidian.enable = lib.mkEnableOption "Enable Obsidian.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
      zotero
    ];

    services.syncthing = {
      enable = true;
      settings.devices = {
        Nico = {
          id = "YZLC2YX-MZ6Y26L-Y5JT76Y-IQHXQLY-GYULNIN-AWHLBTR-XXWRBGK-N3CPCQO";
          name = "server";
        };
      };
    };
  };
}
