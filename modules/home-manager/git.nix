{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.nico.git;
in
{
  options.nico.git.enable = lib.mkEnableOption "Enable configured git.";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "nico";
      userEmail = "nicolaskemp03@proton.me";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };

    home.packages = [
      (import "${inputs.self}/derivations/git-clean-branches.nix" { inherit pkgs; })
    ];
  };
}
