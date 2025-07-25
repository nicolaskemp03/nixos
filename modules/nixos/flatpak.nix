{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.nico.flatpak;

in
{

  options.nico.flatpak.enable = lib.mkEnableOption "Enable Flatpak, Flathub and Software App";

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
    #flathub repository
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      '';
    };

    #Flatpak packages to be installed
    services.flatpak.packages = [
      {
        appId = "com.brave.Browser";
        origin = "flathub";
      }
      "com.dec05eba.gpu_screen_recorder"

    ];
  };

}
