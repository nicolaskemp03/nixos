{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nico.firefox;
  profile = "nico";
  firefox-sidebar = pkgs.fetchFromGitHub {
    owner = "macleod-ee";
    repo = "FirefoxSidebar";
    rev = "a3f9ce26321645ef8f03c6c7a1358dd4abec3e3a";
    hash = "sha256-6C+ltXuVSH4dZszkI7Bx7FT6P5voiBDbnLrGQINwpf8=";
  };
in
{
  options.nico.firefox.enable = lib.mkEnableOption "Enable Firefox.";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;

      policies = {
        DisableTelemetry = true;
        ExtensionSettings =
          with builtins;
          let
            extension = shortId: guid: {
              name = guid;
              value = {
                install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
                installation_mode = "normal_installed";
              };
            };
          in
          listToAttrs [
            # To add additional extensions, find it on addons.mozilla.org, find
            # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
            # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
            (extension "search_by_image" "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}")
            (extension "youtube-shorts-block" "{34daeb50-c2d2-4f14-886a-7160b24d66a4}")
            (extension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}")
            (extension "catppuccin-web-file-icons" "{bbb880ce-43c9-47ae-b746-c3e0096c5b76}")
            (extension "styl-us" "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}")
            (extension "enhancer-for-youtube" "enhancerforyoutube@maximerf.addons.mozilla.org")
            (extension "youtube-addon" "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}")
            (extension "vidiq-vision-youtube" "firefox@vid.io")
            (extension "youtube-no-translation" "{9a3104a2-02c2-464c-b069-82344e5ed4ec}")
            (extension "firefox-color" "FirefoxColor@mozilla.com")
            (extension "shortkeys" "Shortkeys@Shortkeys.com")
            (extension "yt-dlp-downloader" "yt_dlp_firefox@tyilo.com")
          ]
          // {
            "*".installation_mode = "blocked";
          };
      };

      profiles.${profile} = {
        name = profile;

        search = {
          force = true;
          default = "ddg";
          privateDefault = "ddg";

          engines = {
            # Custom search engine for Nix packages
            nix-packages = {
              name = "Nix Packages";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            nix-options = {
              name = "Nix Options";
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "type";
                      value = "options";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };

            # Custom search engine for NixOS Wiki
            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
              definedAliases = [ "@nw" ];
            };

            home-manager-options = {
              name = "Home Manager Options";
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "https://home-manager-options.extranix.com/favicon.ico";
              definedAliases = [ "@hm" ];
            };

            npm-packages = {
              name = "npm-packages";
              urls = [
                {
                  template = "https://www.npmjs.com/search?q={searchTerms}";
                }
              ];
              icon = "https://www.npmjs.com/favicon.ico";
              definedAliases = [ "@npm" ];
            };

            # With lib.rs
            cargo-packages = {
              name = "cargo-packages";
              urls = [
                {
                  template = "https://lib.rs/search?q={searchTerms}";
                }
              ];
              icon = "https://lib.rs/favicon.ico";
              definedAliases = [ "@rs" ];
            };
          };
        };

        settings = {
          # Autoload extensions
          "extensions.autoDisableScopes" = 0;

          "extensions.pocket.enabled" = false;

          "browser.toolbars.bookmarks.visibility" = "never";
          #"browser.tabs.closeWindowWithLastTab" = false; # don't close the window when closing the last tab
          #"sidebar.visibility" = "hide-sidebar";

          "signon.rememberSignons" = false;

          # Theming
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.theme.dark-private-windows" = true;
          "extensions.activeThemeID" = "firefox-dark@mozilla.org";
        };
      };
    };

    home.file = {
      ".mozilla/firefox/${profile}/chrome".source = firefox-sidebar;
      #".mozilla/firefox/${profile}/chrome/userChrome.css".source = ./userChrome.css;
      ".mozilla/firefox/${profile}/sidebery-data.json".source = ./sidebery-data.json;
      ".mozilla/firefox/nico/search.json.mozlz4".force = lib.mkForce true;
    };
  };
}
