{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nico.kde;
in
{
  options.nico.kde.enable = lib.mkEnableOption "Enable KDE";

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
      displayManager.sddm.wayland.enable = true;

    };
    programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
    environment.systemPackages = [
      pkgs.wl-color-picker
      pkgs.hyprpicker
    ];
    #qt.enable = lib.mkForce false;

  };
}
