{ pkgs, ... }: {
  home-manager.users.ehsan.programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = true;
        OfferToSaveLoginsDefault = true;
        PasswordManagerEnabled = true;
        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };
    profiles.spotify = {
      name = "spotify";
      path = "spotify";
      id = 1;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [ switchyomega ];
      isDefault = false;
      search.default = "DuckDuckGo";
      search.force = true;
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.startup.homepage" = "https://open.spotify.com";
      };
    };
    profiles.default = {
      name = "default";
      path = "default";
      id = 0;

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        tridactyl
        switchyomega
      ];
      isDefault = true;
      search.default = "DuckDuckGo";
      search.force = true;
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      };
    };
  };
  environment.systemPackages = [ pkgs.firefox ];
}
