{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.zoxide;
in
{
  imports = [ ../fish.nix ];

  options.nico.zoxide.enable = lib.mkEnableOption "Enable ZOxide.";

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
    }
    // (if config.nico.fish.enable then { enableFishIntegration = true; } else { });

    programs.zsh.envExtra = ''alias cd="z"'';

    programs.fish.shellAliases.cd = "z";
  };
}
