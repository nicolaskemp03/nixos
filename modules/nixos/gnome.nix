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
        #gnome-console
        gnome-logs
        gnome-system-monitor
        gnome-weather
        gnome-connections
        snapshot
        yelp
        gnome-maps
      ]
    );

    services.xserver = {
      excludePackages = [ pkgs.xterm ];
      displayManager.gdm.enable = true;
      desktopManager = {
        gnome.enable = true;
        xterm.enable = false; # disable xterm
      };
    };

    #Fix for display flickering when logging in because of refresh rate changes.
    systemd.services.gdm-setup-monitors = {
      before = [ "display-manager.service" ];
      wantedBy = [ "display-manager.service" ];
      script = ''
        if [[ ! -f /home/nico/.config/monitors.xml ]]; then
          exit 0
        fi
        install -g gdm -o gdm /home/nico/.config/monitors.xml "${config.users.users.gdm.home}/.config"
      '';
    };

    environment.systemPackages =
      with pkgs;
      [
        xwayland-run
        pkgs.dconf2nix
      ]
      ++ (with pkgs.gnomeExtensions; [
        appindicator
        blur-my-shell
        just-perfection
        fuzzy-app-search
        logo-menu
        #quick-settings-tweaker #search for a replacement volume mixer
        clipboard-indicator
        forge
        user-themes
        caffeine
        arcmenu
        gsconnect
      ]);
    services.udev.packages = [ pkgs.gnome-settings-daemon ];

  };
}
