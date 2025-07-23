# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  inputs,
  paths,
  pkgs-unstable,
  nix-flatpak,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    "${paths.nixos}/base_configuration.nix"
    inputs.home-manager.nixosModules.default
    inputs.musnix.nixosModules.musnix
    "${paths.nixos}/gnome.nix"
    "${paths.nixos}/obs.nix"
    "${paths.nixos}/amdgpu.nix"
    "${paths.nixos}/podman.nix"
    "${paths.nixos}/steam.nix"
    "${paths.nixos}/virt.nix"
  ];

  nico.gnome.enable = true;
  nico.amdgpu.enable = true;
  nico.obs-studio.enable = true;
  nico.podman.enable = true;
  nico.steam.enable = true;
  nico.virtualisation.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      nanorc
      clinfo
      pulseaudio
      alsa-utils
      pipewire
      gnome-software # flatpak software
      libsForQt5.xp-pen-deco-01-v2-driver
      piper
      gnome-shell
    ]
    ++ (with pkgs-unstable; [
      rocmPackages.clr.icd
    ]);

  services.flatpak.enable = true;
  #Flatpak packages to be installed
  services.flatpak.packages = [
    {
      appId = "com.brave.Browser";
      origin = "flathub";
    }
    "com.dec05eba.gpu_screen_recorder"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "abi.vsyscall32" = 1; # Enable vsyscall for 32-bit ABI (important for older programs, but generally good practice)
  };

  #Gnome & GDM
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  systemd.services.gdm = {
    enable = lib.mkForce true;
    unitConfig.Mask = lib.mkForce null; # Ensure no internal mask directive
    wantedBy = lib.mkForce [ "graphical.target" ]; # FORCE GDM to be started by the graphical target
  };

  #Graphic Drivers
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true; # Still good practice for proprietary apps
  };

  services.xserver = {
    enable = true;
    # ... other xserver settings like layout ...
    videoDrivers = [ "amdgpu" ]; # Ensure 'amdgpu' is listed here
  };

  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd # Add it here too, ensuring the OpenCL ICD is linked correctly for the driver
    # Also potentially `rocmPackages.clr` if `icd` isn't enough, but `icd` is usually the one.
  ];

  #Networking
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber = {
      enable = true;
    };
  };

  # Audio Solutions

  # <https://wiki.nixos.org/wiki/PipeWire#Low-latency_setup>
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    context.properties = {
      default.clock.rate = 48000;
      default.clock.quantum = 256;
      default.clock.min-quantum = 256;
      default.clock.max-quantum = 256;
    };
  };

  # https://nixos.wiki/wiki/PipeWire#PulseAudio_backend
  #Use pipewire for pulseaudio stuff
  services.pipewire.extraConfig.pipewire-pulse."92-low-latency" = {
    context.modules = [
      {
        name = "libpipewire-module-protocol-pulse";
        args = {
          pulse.min.req = "32/48000";
          pulse.default.req = "32/48000";
          pulse.max.req = "32/48000";
          pulse.min.quantum = "32/48000";
          pulse.max.quantum = "32/48000";
        };
      }
    ];
    stream.properties = {
      node.latency = "32/48000";
      resample.quality = 1;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  musnix.enable = true;
  users.users.nico.extraGroups = [ "audio" ];

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

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
  system.stateVersion = "23.11"; # Did you read the comment?
}
