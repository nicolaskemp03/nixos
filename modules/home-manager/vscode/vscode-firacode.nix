{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.nico.vscode;
in
{
  imports = [ ../firacode.nix ];

  options.nico.vscode.firacode = lib.mkEnableOption "Enable Firacode font.";

  config = lib.mkIf cfg.firacode {
    nico.firacode.enable = true;

    programs.vscode.profiles.default.userSettings = {
      "editor.fontFamily" = "FiraCode Nerd Font, 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontLigatures" = true;
    };
  };
}
