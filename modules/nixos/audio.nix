{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let

  cfg = config.nico.audio;

in
{

  options.nico.audio.enable = lib.mkEnableOption "Enable Audio Configuration";

  config = lib.mkIf cfg.enable {

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

    users.users.nico.extraGroups = [ "audio" ];

  };
}
