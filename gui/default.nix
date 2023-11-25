{ pkgs, unstable, config, ... }:
{
  imports = [ ];
  fonts.fonts = with pkgs;
    [
      font-awesome
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ]; # Select internationalisation properties. i18n.inputMethod.enabled = "fcitx5";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.windowManager.i3.enable = true; # Configure keymap in X11
  services.xserver.layout = "us,ir";
  services.xserver.xkbOptions = "eurosign:e,caps:escape, grp:shifts_toggle";

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  home-manager.users.ehsan = {
    gtk = {
      enable = true;
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
    };
    home.file.i3Config = import ./i3-config.nix { pkgs = pkgs; };
    programs = {
      rofi = {
        enable = true;
        theme = "Adapta-Nokto";
      };

      i3status-rust = {
        enable = true;
        bars = {
          bottom = {
            blocks = [
              {
                block = "time";
                interval = 1;
                format = "$timestamp.datetime(f:'%F %T')";
              }
              {
                block = "custom";
                command = "${pkgs.praytimes-kit}/bin/praytimes-kit next --config ${pkgs.praytimes-config}/etc/praytimes/praytimes.json";
                interval = 10;
              }
              {
                block = "music";
                format = " $icon {$combo.str(max_w:20,rot_interval:0.5) $prev $play $next |}";
                interface_name_exclude = [ ".*kdeconnect.*" "mpd" ];
              }
              {
                block = "cpu";
                interval = 1;
                click = [{
                  button = "left";
                  cmd = "gnome-system-monitor";
                }];
              }
              {
                block = "memory";
                format = " $icon $mem_used_percents.eng(w:1) ";
                interval = 30;
                warning_mem = 70;
                critical_mem = 90;
              }
              {
                block = "net";
                format = "$icon $ip via {$ssid($signal_strength)|Wired connection} ^icon_net_down $speed_down.eng(prefix:K) ^icon_net_up $speed_up.eng(prefix:K) ";
                click = [{
                  button = "left";
                  cmd = "nm-connection-editor";
                }];
              }
            ] ++
            (if (config.system == "nixos-laptop") then [{ block = "battery"; format = "$icon $percentage {$time |}"; format_missing = ""; }] else [ ]) ++
            [
              {
                block = "sound";
                click = [{
                  button = "left";
                  cmd = "pavucontrol";
                }];
              }
              {
                block = "custom";
                command = "${pkgs.xkb-switch}/bin/xkb-switch";
                interval = 1;
              }
            ];
            settings = {
              theme = {
                theme = "modern";
              };
            };
            icons = "awesome5";
            theme = "gruvbox-dark";
          };
        };
      };
      alacritty = {
        enable = true;
      };
      firefox = {
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
    };

  };
  services.redshift.enable = true;
  environment.systemPackages = with pkgs; [
    alacritty
    # Window manager and utils
    rofi
    xorg.xmodmap
    libnotify
    dunst
    translate-shell
    xsel
    dunst
    dmenu
    rofi
    flameshot
    i3status

    firefox
    xarchiver
    discord
    unstable.tdesktop
    chromium
    tor-browser-bundle-bin
    spotify

  ];
}
