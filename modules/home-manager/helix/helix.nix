{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.nico.vscode;
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions."x86_64-linux";
in
{
  imports = [ ];

  options.nico.helix.enable = lib.mkEnableOption "Enable Helix.";

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
    };
  };
}
