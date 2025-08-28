# Configuration common to all computers
{
  inputs,
  pkgs,
  lib,
  paths,
  ...
}:
let
  mkDefault = lib.mkDefault;
in

{
  imports = [
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "nico" ])
  ];

  home-manager.backupFileExtension = "backup";

  # Enable flakes
  nix.settings.experimental-features = mkDefault [
    "nix-command"
    "flakes"
  ];

  networking.hosts = {
    "192.168.95.132" = [ "homeserver.cl" ];
  };
  # Set timezone
  time.timeZone = mkDefault "America/Santiago";

  # Set locales
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  i18n.extraLocaleSettings = mkDefault {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  # Set keyboard layout for console and xserver
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };
  console.keyMap = "la-latin1";

  # My user
  users.users.nico = {
    isNormalUser = true;
    description = "nico";
    home = "/home/nico";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
  };

  environment.systemPackages = with pkgs; [
    file
    nixfmt-rfc-style
    libnotify
    nanorc
    nh
    nil
    appimage-run
    mission-center
    pavucontrol
    (import "${paths.derivations}/rebuild.nix" { inherit pkgs; })
    (import "${paths.derivations}/font-cache-update.nix" { inherit pkgs; })
  ];

  environment.sessionVariables = {
    EDITOR = "nano";
    NH_FLAKE = "/home/nico/nixos-config";
  };

  services.flatpak.enable = true;
  #flathub repository
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  #Flatpak packages to be installed
  services.flatpak.packages = [
    {
      appId = "com.brave.Browser";
      origin = "flathub";
    }
    "com.dec05eba.gpu_screen_recorder"

  ];
  programs.ssh.startAgent = mkDefault false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = mkDefault true;
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

}
