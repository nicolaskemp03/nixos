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

    # This copies your user's monitors.xml to GDM's configuration directory
    # so GDM uses your preferred resolution/refresh rate from boot.

    system.activationScripts.copyGdmMonitorsConfig = {
      deps = [ "specialfs" ];
      text = ''
        set -x # Enable verbose script execution for debugging

        MONITORS_SRC="/home/nico/.config/monitors.xml"
        GDM_CONFIG_DIR="/var/lib/gdm/.config"
        GDM_MONITORS_FILE="$GDM_CONFIG_DIR/monitors.xml"

        echo "--- GDM Monitors.xml Copy Script ---"
        echo "Attempting to copy monitors.xml for GDM."
        echo "Source: $MONITORS_SRC"
        echo "Destination: $GDM_MONITORS_FILE"

        if [ -f "$MONITORS_SRC" ]; then
          echo "Source monitors.xml exists. Content preview (first 10 lines):"
          cat "$MONITORS_SRC" | head -n 10

          mkdir -p "$GDM_CONFIG_DIR"
          cp "$MONITORS_SRC" "$GDM_MONITORS_FILE"

          if [ $? -eq 0 ]; then
            echo "monitors.xml copied successfully. Setting permissions."
            chown gdm:gdm "$GDM_MONITORS_FILE"
            chmod 644 "$GDM_MONITORS_FILE"
            echo "Permissions set. Verifying destination content and permissions:"
            ls -l "$GDM_MONITORS_FILE"
            cat "$GDM_MONITORS_FILE" | head -n 10
            echo "--- GDM Monitors.xml Copy Script Success ---"
          else
            echo "Error: Failed to copy monitors.xml." >&2
            echo "--- GDM Monitors.xml Copy Script Failed ---"
          fi
        else
          echo "Warning: User's monitors.xml not found at $MONITORS_SRC. GDM might not use preferred display settings." >&2
          echo "--- GDM Monitors.xml Copy Script Warning ---"
        fi
      '';
    };

    system.activationScripts.clearGdmDconfCache = {
      deps = [ "specialfs" ];
      text = ''
        echo "Clearing GDM dconf cache..."
        # Ensure sudo is in the PATH for this script by referencing its Nix store path
        ${pkgs.sudo}/bin/sudo -u gdm ${pkgs.dconf}/bin/dconf reset -f /org/gnome/mutter/display-config/
        ${pkgs.sudo}/bin/sudo -u gdm ${pkgs.dconf}/bin/dconf reset -f /org/gnome/mutter/displays/
        echo "GDM dconf cache cleared."
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
