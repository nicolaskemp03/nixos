{
  config,
  pkgs,
  paths,
  inputs,
  pkgs-unstable,
  nix-flatpak,
  ...
}:
{
  imports = [

    #System
    "${paths.homeManager}/base_configuration.nix"
    "${paths.homeManager}/git.nix"
    "${paths.homeManager}/gnome/gnome.nix"

    #Basic Apps
    "${paths.homeManager}/browser/firefox.nix"
    "${paths.homeManager}/discord.nix"
    "${paths.homeManager}/flatpak.nix"
    "${paths.homeManager}/rofi/rofi.nix"

    #Utilities and tools
    "${paths.homeManager}/obsidian.nix"
    "${paths.homeManager}/raysession.nix"
    "${paths.homeManager}/libreoffice.nix"
    "${paths.homeManager}/blender.nix"
    "${paths.homeManager}/vscode/vscode.nix"
    "${paths.homeManager}/davinci.nix"
    "${paths.homeManager}/affinity.nix"

    #Terminal and Coding
    "${paths.homeManager}/shell/utils/shell-utils.nix"
    "${paths.homeManager}/shell/gitui.nix"
    "${paths.homeManager}/shell/kitty.nix"
    "${paths.homeManager}/shell/fish.nix"
    "${paths.homeManager}/shell/warp.nix"

    #Gaming
    "${paths.homeManager}/games/minecraft.nix"
    "${paths.homeManager}/games/games-emulation.nix"

  ];

  #System
  nico.git.enable = true;
  nico.gnome.enable = true;
  nico.gnome.catppuccin.enable = true;
  #nico.gnome.background.enable = true;
  #nico.gnome.background.path = "persona_3_blue_down.png";

  #Basic Apps
  nico.firefox.enable = true;
  nico.discord.enable = true;
  programs.firefox.enable = true;
  nico.flatpak.enable = true;
  nico.rofi.enable = true;

  #Utilities and Tools
  nico.blender.enable = false;
  nico.libreoffice.enable = true;
  nico.obsidian.enable = true;
  nico.raysession.enable = true;
  davinci.enable = true;
  nico.affinity.enable = false;

  #Terminal and Coding
  nico.fish.enable = true;
  nico.shell-utils.enable = true;
  nico.warp-terminal.enable = true;

  nico.gitui.enable = true;
  nico.kitty.enable = true;
  nico.firacode.enable = true;

  nico.vscode = {
    enable = true;
    catppuccin = true;
    firacode = true;
    #java = true;
    #js = true;
    #rust = true;
    #vim = true;
  };

  #Gaming
  nico.games.minecraft.enable = true;
  nico.games.emulation.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
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
    pkgs.pavucontrol
    pkgs.mission-center
    pkgs.whatsie
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
  home.sessionVariables = {
    #EDITOR = "nvim";
    #BROWSER = "firefox";
    TERMINAL = "kitty";
  };
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
  # home.sessionVariables = {
  #   EDITOR = "nvim";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
