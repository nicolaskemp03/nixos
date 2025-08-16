# ~/.config/nixpkgs/home-manager/davinci.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.davinci;

  # Define necessary dependencies for the override script
  # These are standard Nixpkgs packages for shell scripting and Perl
  bash = pkgs.bash;
  perl = pkgs.perl;
  writeText = pkgs.writeText;
  xkeyboard_config = pkgs.xkeyboard_config; # For QT_XKB_CONFIG_ROOT

  # Define the overridden DaVinci Resolve package here
  davinciResolveStudioOverridden = pkgs.unstable.davinci-resolve-studio.override (old: {
    buildFHSEnv =
      fhs:
      (
        let
          # This is the actual DaVinci binary, we can run perl here
          # You NEED to fill in the REGEX part here with your specific modification!
          davinci = fhs.passthru.davinci.overrideAttrs (oldAttrs: {
            # Use oldAttrs for clarity
            postFixup = ''
              ${oldAttrs.postFixup or ""} # Ensure old postFixup commands are preserved
              # IMPORTANT: Replace <YOUR_PERL_REGEX_COMMAND_HERE> with your actual command
              # Example: ${perl}/bin/perl -pi -e 's|OLD_STRING|NEW_STRING|g' $out/bin/resolve
              echo "Applying custom patch to DaVinci Resolve binary (if any specified)..."
              ${perl}/bin/perl -pi -e 's/\x74\x11\xe8\x21\x23\x00\x00/\xeb\x11\xe8\x21\x23\x00\x00/g' $out/bin/resolve
            '';
          });
        in
        # This part overrides the wrapper, we need to replace all of the instances of ${davinci} with the patched version
        # Copies the parts from the official nixpkgs derivation that need overriding
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/da/davinci-resolve/package.nix
        old.buildFHSEnv (
          fhs
          // {
            extraBwrapArgs = [
              # Assuming your license file is at ~/.local/share/DaVinciResolve/license
              # If you use the Free version or don't have a local license file, you might not need this.
              #"--bind \"${config.home.homeDirectory}/.local/share/DaVinciResolve/license\" ${davinci}/.license"
              # Added from https://discourse.nixos.org/t/davinci-resolve-studio-install-issues/37699/44
              #"--bind /run/opengl-driver/etc/OpenCL /etc/OpenCL"
            ];
            runScript = "${bash}/bin/bash ${writeText "davinci-wrapper" ''
              export QT_XKB_CONFIG_ROOT="${xkeyboard_config}/share/X11/xkb"
              export QT_PLUGIN_PATH="${davinci}/libs/plugins:$QT_PLUGIN_PATH"
              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${davinci}/libs
              unset QT_QPA_PLATFORM # Having this set to wayland causes issues
              ${davinci}/bin/resolve
            ''}";
            extraInstallCommands = ''
              mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps
              ln -s ${davinci}/share/applications/*.desktop $out/share/applications/
              ln -s ${davinci}/graphics/DV_Resolve.png $out/share/icons/hicolor/128x128/apps/davinci-resolve-studio.png
            '';
            passthru = { inherit davinci; };
          }
        )
      );
  });

in
{
  options.davinci.enable = lib.mkEnableOption "Enable davinci.";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      davinciResolveStudioOverridden # Use the overridden package here
      pkgs.audacity
    ];
  };
}
