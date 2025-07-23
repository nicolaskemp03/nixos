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
    services.xserver.config = ''
          Section "Monitor"
        Identifier "DP-1" # Replace with the name identified by xrandr (e.g., "DisplayPort-0")
        Option "PreferredMode" "2560x1440" # Replace with your resolution
        Option "RefreshRate" "143.87"
      EndSection

      Section "Screen"
        Identifier "Default Screen"
        Monitor "DP-1" # Must match the Identifier in the Monitor section
        DefaultDepth 24
        SubSection "Display"
          Depth 24
          Modes "2560x1440@143.87" # Your resolution and refresh rate
        EndSubSection
      EndSection

      Section "Device"
        Identifier "Default Device"
        # You might need to specify your GPU driver here if you have issues, e.g., "nvidia", "amdgpu", "intel"
        # Driver "nvidia"
      EndSection
    '';

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
