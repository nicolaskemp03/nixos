# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  inputs,
  paths,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    "${paths.nixos}/base_configuration.nix"
    inputs.home-manager.nixosModules.default
    "${paths.nixos}/gnome.nix"
    "${paths.nixos}/obs.nix"
    "${paths.nixos}/amdgpu.nix"
    "${paths.nixos}/steam.nix"
    "${paths.nixos}/virt.nix"
    "${paths.nixos}/audio.nix"
    "${paths.nixos}/flatpak.nix"
    "${paths.nixos}/wine.nix"
  ];

  nico.gnome.enable = true;
  nico.amdgpu.enable = true;
  nico.obs-studio.enable = true;
  nico.steam.enable = true;
  nico.wine.enable = true;
  nico.virtualisation.enable = true;
  nico.audio.enable = true;
  nico.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    nanorc
    clinfo
    libsForQt5.xp-pen-deco-01-v2-driver
    piper
    unrar
    onedrivegui
  ];
  services.ratbagd.enable = true;
  services.onedrive.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "abi.vsyscall32" = 1; # Enable vsyscall for 32-bit ABI (important for older programs, but generally good practice)
  };

  #Networking
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs paths; };
    users = {
      "nico" = import ./home.nix;
    };
    useGlobalPkgs = true;
  };

  nixpkgs.config.supportedSystems = [
    "x86_64-linux"
    "i686-linux"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  environment.pathsToLink = [ "/share/zsh" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
