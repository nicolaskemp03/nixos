{
  config,
  pkgs,
  lib,
  affinity-nix,
  inputs,
  ...
}:
let
  cfg = config.nico.affinity;
in
{
  options.nico.affinity.enable = lib.mkEnableOption "Enable Affinity Suite.";

  #config = lib.mkIf cfg.enable {
  #home.packages = with pkgs; [
  #inputs.affinity-nix.packages.x86_64-linux.photo
  #inputs.affinity-nix.packages.x86_64-linux.designer
  #inputs.affinity-nix.packages.x86_64-linux.publisher
  #];
  #};
}
