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

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";
      targets.qt.enable = true;
      autoEnable = false;
      targets.nixos-icons.enable = true;
    };

    hm.stylix.targets = {
      kde.enable = true;
      kitty.enable = true;
      vscode = {
        enable = true;
        profileNames = [
          "default"
        ];
      };
    };

  };
}
