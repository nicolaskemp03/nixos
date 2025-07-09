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
    };
  };
}
