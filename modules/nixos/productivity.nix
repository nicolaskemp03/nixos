{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

let

  cfg = config.nico.productivity;

in
{

  options.nico.productivity.enable = lib.mkEnableOption "Enable productivity and gestion applications";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      obsidian
      zotero
    ];

    hm.services.syncthing = {
      enable = true;
      settings = {
        devices = {
          server = {
            addresses = [
              "tcp://192.168.95.132:8384"
            ];
            id = "YZLC2YX-MZ6Y26L-Y5JT76Y-IQHXQLY-GYULNIN-AWHLBTR-XXWRBGK-N3CPCQO";
          };
        };
        devices.nico = {
          id = "YZLC2YX-MZ6Y26L-Y5JT76Y-IQHXQLY-GYULNIN-AWHLBTR-XXWRBGK-N3CPCQO";
          name = "server";
        };
        folders.nico = {
          devices = [ "server" ];
          id = "njmxe-qcewt";
          label = "~/Documents/Obsidian";
          path = "~/Documents/Obsidian";
          type = "sendreceive";
        };
      };
    };

  };
}
