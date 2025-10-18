{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nico.amdgpu;
in
{
  options.nico.amdgpu.enable = lib.mkEnableOption "Enable AMDGPU support";

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd # For OpenCL
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        # AMDVLK also has a 32-bit version which can be useful
      ];
    };

    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver = {
      enable = true;
      # ... other xserver settings like layout ...
      videoDrivers = [ "amdgpu" ]; # Ensure 'amdgpu' is listed here
    };

    # I don't know what this was for and until knowing it it must be here.

    systemd.tmpfiles.rules =
      let
        rocmEnv = pkgs.symlinkJoin {
          name = "rocm-combined";
          paths = with pkgs.rocmPackages; [
            rocblas
            hipblas
            clr
          ];
        };
      in
      [
        "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
      ];

    environment.systemPackages = [ pkgs.lact ];
    systemd.packages = [ pkgs.lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];
  };
}
