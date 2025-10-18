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
    "192.168.95.132" = [
      "homeserver.cl"
      "n8n.homeserver.cl"
    ];
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

  #Set mount settings
  fileSystems."/run/media/nico/40b9ab55-f044-4a52-84b6-b01f7dce6fb6" = {
    device = "/dev/disk/by-uuid/40b9ab55-f044-4a52-84b6-b01f7dce6fb6";
    fsType = "ext4";
    options = [
      "nofail"
      "x-gvfs-show"
    ];
  };

  fileSystems."/run/media/nico/SSD" = {
    device = "/dev/disk/by-uuid/2A90ECC790EC9A99";
    fsType = "ntfs";
    options = [
      "nofail"
      "x-gvfs-show"
    ];
  };

  fileSystems."/run/media/nico/HDD" = {
    device = "/dev/disk/by-uuid/DC086035086010B6";
    fsType = "ntfs";
    options = [
      "nofail"
      "x-gvfs-show"
    ];
  };

  fileSystems."/run/media/nico/2C9C73ED9C73B046" = {
    device = "/dev/disk/by-uuid/2C9C73ED9C73B046";
    fsType = "ntfs";
    options = [
      "nofail"
      "x-gvfs-show"
    ];
  };

  fileSystems."/run/media/nico/Games" = {
    device = "/dev/disk/by-uuid/EE60124A60121A43";
    fsType = "ntfs";
    options = [
      "nofail"
      "x-gvfs-show"
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
    nvtopPackages.amd
    btop
    blueman
    openrgb
    (import "${paths.derivations}/rebuild.nix" { inherit pkgs; })
    (import "${paths.derivations}/font-cache-update.nix" { inherit pkgs; })
    jq
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  environment.sessionVariables = {
    EDITOR = "nano";
    NH_FLAKE = "/home/nico/nixos-config";
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # Enable the gnome-keyring service
  services.gnome.gnome-keyring = {
    enable = true;

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
      appId = "app.zen_browser.zen";
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

  hm = {
    home.packages = with pkgs; [
      (import "${paths.derivations}/bg-run.nix" { inherit pkgs; })
      trashy
      vlc
    ];
    imports = [
      inputs.vicinae.homeManagerModules.default
    ];

    xdg.desktopEntries = {
      "Rebuild" = {
        name = "Rebuild";
        genericName = "Rebuild NixOS";
        exec = ''bash -c "rebuild ; echo \\"Press enter to close this window...\\" ; read ans" '';
        terminal = true;
        icon = "utilities-terminal";
      };
    };
  };

}
