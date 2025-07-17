{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nico.gnome;
in
{
  options.nico.gnome.enable = lib.mkEnableOption "Enable GNOME and GDE";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = (
      with pkgs;
      [
        cheese # webcam tool
        epiphany # web browser
        geary # email reader
        evince # document viewer
        totem # video player
        # gnome-photos
        gnome-tour
        gedit # text editor
        gnome-music
        gnome-characters
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        gnome-console
        gnome-logs
        gnome-system-monitor
        gnome-weather
        gnome-connections
        snapshot
        yelp
      ]
    );

    environment.systemPackages = with pkgs; [
      xwayland-run
      gnomeExtensions.appindicator
    ];
    services.udev.packages = [ pkgs.gnome-settings-daemon ];
  };
}
