{
  config,
  pkgs,
  paths,
  inputs,
  pkgs-unstable,
  ...
}:
{

  imports = [
    #Basic Apps
    "${paths.homeManager}/browser/firefox.nix"
    "${paths.homeManager}/discord.nix"

    #Utilities and tools
    "${paths.homeManager}/libreoffice.nix"
  ];

  #Basic Apps
  nico.firefox.enable = true;
  nico.discord.enable = true;

  #Utilities and Tools
  nico.libreoffice.enable = true;

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "nico";
  home.homeDirectory = "/home/nico";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = [
    pkgs.qbittorrent
    pkgs.finamp
    pkgs.ente-auth
    pkgs.droidcam
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  services.vicinae = {
    enable = true; # default: false
    autoStart = true; # default: true
    themes = {
      "rose-pine-dawn" = {
        version = "1.0.0";
        appearance = "light"; # Rosé Pine Dawn es un tema claro.
        name = "Rosé Pine Dawn";
        # Asegúrate de que los colores y otros atributos coincidan exactamente
        # con el archivo JSON del tema.
        palette = {
          # ... inserta aquí el resto del contenido del archivo JSON
          background = "#faf4ed";
          foreground = "#575279";
          blue = "#286983";
          green = "#56949f";
          magenta = "#907aa9";
          orange = "#ea9d34";
          purple = "#d7827e";
          muted = "#9893a5";
          # ... y así sucesivamente
        };
        # Si el tema tiene otros campos, añádelos aquí.
      };
    };
    settings = {
      theme = {
        name = "rose-pine-dawn";
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nico/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    #EDITOR = "nano";
    #BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
