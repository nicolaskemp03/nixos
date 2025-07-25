{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.gnome;
in
{

  options.nico.gnome.enable = lib.mkEnableOption "Enable GNOME config.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-tweaks
    ];

    gtk = {
      enable = true;

      iconTheme = {
        name = "Nordzy";
        package = pkgs.nordzy-icon-theme;
      };

      theme = {
        name = "Graphite";
        package = pkgs.graphite-gtk-theme.override {
          tweaks = [ "nord" ];
          themeVariants = [ "purple" ];
        };
      };
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
        # Erasing super + space shortcuts
        switch-input-source = [ ];
        switch-input-source-backward = [ ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        home = [ "<Super>e" ];
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
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
}
