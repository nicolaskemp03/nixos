{
  config,
  lib,
  pkgs,
  home-manager,
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
      desktopManager = {
        gnome.enable = false;
        xterm.enable = false; # disable xterm
      };
    };

    #Fix for display flickering when logging in because of refresh rate changes.

    /*
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
           dconf2nix
           gnome-software
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

       home-manager.users.nico = {
         home.packages = [
           pkgs.gnome-tweaks
         ];

         gtk = {
           enable = true;

             iconTheme = {
                    name = "Zafiro-icons-Dark";
                    package = pkgs.zafiro-icons;
                  };

                  theme = {
                    name = "Graphite";
                    package = pkgs.graphite-gtk-theme.override {
                      tweaks = [ "nord" ];
                      themeVariants = [ "purple" ];
                    };
                  };

         };

         home.activation = {
           pre-switch-clean = ''
             echo "Cleaning up conflicting gtkrc-2.0 file..."
             rm -f ~/.gtkrc-2.0
             rm -f ~/.gtkrc-2.0.backup
           '';
         };

           home.pointerCursor = {
                gtk.enable = true;
                name = "Afterglow-Recolored-Gruvbox-Purple";
                package = pkgs.afterglow-cursors-recolored;
                size = 24;
              };

         dconf.settings = {

           #Gnome Theming
             "org/gnome/desktop/interface" = {
                    color-scheme = "prefer-dark";
                    enable-hot-corners = false;
                  };

             "org/gnome/shell/extensions/user-theme" = {
                  name = "Graphite";
                };

             "org/gnome/desktop/background" = {
                    picture-uri = "/home/nico/nixos-config/modules/home-manager/gnome/IF_Background_Cachi.jpg";
                    picture-uri-dark = "/home/nico/nixos-config/modules/home-manager/gnome/IF_Background_Cachi.jpg";
                  };

           #Peripherals
           "org/gnome/desktop/peripherals/touchpad" = {
             click-method = "areas";
             tap-to-click = true;
             two-finger-scrolling-enabled = true;
           };

           "org/gnome/settings-daemon/plugins/power" = {
             power-button-action = "nothing";
             #sleep-inactive-ac-type = "nothing";
             #sleep-inactive-battery-type = "nothing";
           };

           #Shortcuts
           "org/gnome/desktop/wm/keybindings" = {
             # Erasing super + space shortcuts and setting other shortcuts
             switch-input-source = [ ];
             switch-input-source-backward = [ ];
             close = "['<Control>q']";
           };

             "/org/gnome/shell/keybindings" = {
                  show-screenshot-ui = "['<Shift><Super>s']";

                };

           "org/gnome/settings-daemon/plugins/media-keys" = {
             home = [ "<Super>e" ];
             custom-keybindings = [
               "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
               "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
               "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
               "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
             ];
           };

           "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
             name = "kitty";
             command = "kitty";
             binding = "<Super>t";
           };

           "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
             name = "rofi";
             command = "rofi -normal-window -show combi -combi-modes \"window,drun,run\" -modes combi";
             binding = "<Super>space";
           };

           "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
             name = "rebuild";
             command = "kitty -- bash -c \"rebuild ; echo \\\"Press enter to close this window...\\\" ; read ans\"";
             binding = "<Super>r";
           };

           "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
             name = "firefox";
             command = "firefox";
             binding = "<Super>f";
           };

           #Extension enabling
           "org/gnome/shell" = {
             disable-user-extension = false;
             enabled-extensions = [
               "user-theme@gnome-shell-extensions.gcampax.github.com"
               "appindicatorsupport@rgcjonas.gmail.com"
               "blur-my-shell@aunetx"
               "clipboard-indicator@tudmotu.com"
               "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
               "just-perfection-desktop@just-perfection"
               "logomenu@aryan_k"
             ];
           };
         };

       };
    */
  };
}
