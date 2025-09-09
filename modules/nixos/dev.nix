{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

let

  cfg = config.nico.dev;

in
{

  options.nico.dev.enable = lib.mkEnableOption "Enable productivity and gestion applications";

  config = lib.mkIf cfg.enable {

    hm = {

      home.sessionVariables = {
        "NIX_CONFIG_EDITOR" = "code-nw";
      };

      systemd.user.sessionVariables = {
        "NIX_CONFIG_EDITOR" = "code-nw";
      };
      home.packages = [
        (import "${inputs.self}/derivations/code-nw.nix" { inherit pkgs; })
      ];

      programs.vscode = {
        enable = true;
        mutableExtensionsDir = true;

        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;

          extensions =
            (with pkgs.vscode-extensions; [
              mkhl.direnv
              jnoortheen.nix-ide

              usernamehw.errorlens

              redhat.vscode-yaml
              tamasfe.even-better-toml

              ms-vsliveshare.vsliveshare
              ms-vscode-remote.remote-ssh
              ms-vscode-remote.remote-containers
              ms-python.python
              ms-python.debugpy

              ms-toolsai.jupyter
              ms-toolsai.jupyter-keymap
              ms-toolsai.vscode-jupyter-slideshow
              ms-toolsai.vscode-jupyter-cell-tags
              ms-toolsai.jupyter-renderers

              vscodevim.vim
            ])
            ++ (with pkgs.vscode-marketplace; [
              gruntfuggly.todo-tree
              vivaxy.vscode-conventional-commits
            ]);

          userSettings = {
            "git.autofetch" = "all";
            "git.allowNoVerifyCommit" = true;
            "conventionalCommits.promptScopes" = false;
            "conventionalCommits.promptBody" = false;
            "conventionalCommits.promptFooter" = false;

            "editor.formatOnSave" = true;
            "editor.tabCompletion" = "on";

            "terminal.integrated.defaultProfile.linux" = "fish";
            "terminal.integrated.scrollback" = 10000;
            "workbench.sideBar.location" = "right";

            "nix.enableLanguageServer" = true;
            "nix.serverPath" = lib.getExe pkgs.nil;
            "nix.serverSettings" = {
              "nil" = {
                "formatting" = {
                  "command" = [ "nixfmt" ];
                };
              };
              "nixd" = {
                "formatting" = {
                  "command" = [ "nixfmt" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
