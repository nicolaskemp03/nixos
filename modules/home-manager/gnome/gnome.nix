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
  imports = [
    ./catppuccin.nix
    ./backgrounds.nix
  ];

  options.nico.gnome.enable = lib.mkEnableOption "Enable GNOME config.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-tweaks
      pkgs.dconf2nix
    ];

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
      };

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

      "org/gnome/desktop/wm/keybindings" = {
        switch-input-source = [ ];
        switch-input-source-backward = [ ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        home = [ "<Super>e" ];
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
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
    };
  };
}
