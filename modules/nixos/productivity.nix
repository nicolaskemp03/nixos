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
      kdePackages.francis
      pomodoro-gtk
      yt-dlp
      thunderbird
      localsend
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

    hm.programs.git = {
      enable = true;
      userName = "nico";
      userEmail = "nicolaskemp03@proton.me";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };

    hm.home.packages = [
      (import "${inputs.self}/derivations/git-clean-branches.nix" { inherit pkgs; })
    ];

    #Notification to remind me to work
    services.cron.enable = true;
    services.cron.systemCronJobs = [

      "description = \"Daily project reminder\";
        command = \"notify-send --expire-time=30000 --urgency=critical 'Hora de Proyectos' 'Dedica una hora a tus proyectos de Obsidian.'\";
        time = \"0 19 * * *\";" # Send the notification at 7:00 PM

    ];

  };
}
