{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

let

  cfg = config.nico.terminal;

in
{

  options.nico.terminal.enable = lib.mkEnableOption "Enable productivity and gestion applications";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      tldr
      dust
      ripgrep
    ];

    hm = {
      programs.kitty.enable = true;
      programs.kitty.extraConfig = ''
        background_opacity 0.95
        map ctrl+shift+f next_window
        map ctrl+shift+b previous_window
      '';

      programs.gitui = {
        enable = true;
      };

      programs.fish = {
        enable = true;

        plugins = [
          {
            name = "tide";
            src = pkgs.fishPlugins.tide.src;
          }
          {
            name = "autopair";
            src = pkgs.fishPlugins.autopair.src;
          }
          {
            name = "puffer";
            src = pkgs.fishPlugins.puffer.src;
          }
        ];
      };

      programs.bash = {
        enable = true;
        initExtra = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
      };

      programs.command-not-found.enable = true;

      programs.fd.enable = true;
      programs.bat.enable = true;

      programs.zoxide = {
        enable = true;
      };

      programs.zsh.envExtra = ''alias cd="z"'';

      programs.fish.shellAliases.cd = "z";

    };
  };
}
