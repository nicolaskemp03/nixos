{
  config,
  lib,
  pkgs,
  hm,
  home-manager,
  ...
}:
let
  cfg = config.nico.theme;
in
{
  options.nico.theme.enable = lib.mkEnableOption "Enable Stylix";

  config = lib.mkIf cfg.enable {

    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";
    stylix.targets.qt.enable = true;
    stylix.autoEnable = false;

    hm = {
      stylix.targets.kitty.enable = true;
      stylix.targets.vscode = {
        enable = true;
        profileNames = [
          "default"
        ];
      };
    };

  };
}
