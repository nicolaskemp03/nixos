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
    services.xserver.displayManager.gdm.settings = {
      "org/gnome/desktop/interface" = {
        icon-theme = "Zafiro-icons-Dark";
        cursor-theme = "Afterglow-Recolored-Gruvbox-Purple";
        gtk-theme = "Graphite";
      };
    };
    services.xserver.desktopManager.gnome.enable = true;

    # This copies your user's monitors.xml to GDM's configuration directory
    # so GDM uses your preferred resolution/refresh rate from boot.
    system.activationScripts.copyGdmMonitorsConfig = {
      deps = [ "specialfs" ];
      text = ''
        MONITORS_SRC="/home/nico/.config/monitors.xml" # <--- Hardcode your username "nico"
        GDM_CONFIG_DIR="/var/lib/gdm/.config"
        GDM_MONITORS_FILE="$GDM_CONFIG_DIR/monitors.xml"

        if [ -f "$MONITORS_SRC" ]; then
          mkdir -p "$GDM_CONFIG_DIR"
          cp "$MONITORS_SRC" "$GDM_MONITORS_FILE"
          chown gdm:gdm "$GDM_MONITORS_FILE"
          chmod 644 "$GDM_MONITORS_FILE"
          echo "Copied user's monitors.xml to GDM config."
        else
          echo "Warning: User's monitors.xml not found at $MONITORS_SRC, GDM might not use preferred display settings." >&2
        fi
      '';
    };

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
      ]
    );

    services.xserver.excludePackages = [ pkgs.xterm ];
    services.xserver.desktopManager.xterm.enable = false;

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
      ]);
    services.udev.packages = [ pkgs.gnome-settings-daemon ];

  };
}
