{
  pkgs,
  inputs,
  paths,
  ...
}:
{
  imports = [
  ];

  config = {

    home.packages = with pkgs; [
      (import "${paths.derivations}/bg-run.nix" { inherit pkgs; })
      trashy
      vlc
    ];

    xdg.desktopEntries = {
      "Rebuild" = {
        name = "Rebuild";
        genericName = "Rebuild NixOS";
        exec = ''bash -c "rebuild ; echo \\"Press enter to close this window...\\" ; read ans" '';
        terminal = true;
        icon = "utilities-terminal";
      };
    };
  };
}
