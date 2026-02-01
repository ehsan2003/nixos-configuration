{ config, pkgs, ... }:
let
  is-laptop = (
    config.networking.hostName == "nixos-laptop" || config.networking.hostName == "nixos-new-laptop"
  );
in
{
  home-manager.users.ehsan.xdg.configFile."waybar/config" = {
    text = builtins.toJSON {
      layer = "top";
      ipc = true;
      position = "bottom";
      height = 48;
      "modules-left" = [ "sway/workspaces" ];
      "modules-center" = [ ];
      "modules-right" = (
        if is-laptop then
          [
            "sway/mode"
            "sway/window"
            "mpris"
            "network"
            "cpu"
            "memory"
            "battery"
            "backlight"
            "temperature"
            "idle_inhibitor"
            "pulseaudio"
            "custom/keyboard"
            "custom/prayer-times"
            "clock"
            "tray"
          ]
        else
          [
            "sway/mode"
            "sway/window"
            "mpris"
            "network"
            "cpu"
            "memory"
            "idle_inhibitor"
            "pulseaudio"
            "custom/keyboard"
            "custom/prayer-times"
            "clock"
            "tray"
          ]
      );
      "sway/workspaces" = {
        disable-scroll = false;
        all-outputs = true;
        format = "{icon}";
        format-icons = {
          "1" = "💻";
          "2" = "🌐";
          "3" = "⬛";
          "4" = "🤖";
          "5" = "💬";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "10";

          urgent = "";
          default = "";
        };
      };
      "sway/mode" = {
        format = "{}";
      };
      "sway/window" = {
        format = "{}";
        max-length = 40;
      };
      mpris = {
        format = "{player_icon} {dynamic(maxLength:30, interval:0.5)}";
        player-blacklist = [
          "kdeconnect.*"
          "mpd"
        ];
      };
      network = {
        format = "{ifname}";
        format-wifi = " {ipaddr} - {essid} ({signalStrength}%) ▼{bandwidthDownOctets:>} ▲{bandwidthUpOctets:>}";
        format-ethernet = " {ipaddr} (Wired) ▼{bandwidthDownBits:>} ▲{bandwidthUpBits:>}";
        format-disconnected = " Disconnected";
        interval = 3;
        tooltip = false;
      };
      cpu = {
        format = " {usage}%";
        interval = 1;
      };
      memory = {
        format = " {percentage}%";
        interval = 10;
        states = {
          warning = 70;
          critical = 90;
        };
      };
      battery = {
        format = "{icon} {capacity}%";
        format-charging = "{icon} {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{icon} {capacity}% ({time})";
        format-time = "{H}h {M}min";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];

        states = {
          warning = 30;
          critical = 15;
        };
        interval = 30;
      };
      backlight = {
        format = "{icon}";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };
      temperature = {
        format = "{temperatureC}°C";
        interval = 3;
        warning-threshold = 80;
        critical-threshold = 90;
      };
      pulseaudio = {
        "format" = "{volume}% {icon} {format_source}";
        "format-bluetooth" = "{volume}% {icon} {format_source}";
        "format-bluetooth-muted" = " {icon} {format_source}";
        "format-muted" = " {format_source}";
        "format-source" = "{volume}% ";
        "format-source-muted" = "";
        "format-icons" = {
          "headphone" = "";
          "hands-free" = "";
          "headset" = "";
          "phone" = "";
          "portable" = "";
          "car" = "";
          "default" = [
            ""
            ""
            ""
          ];
        };

        on-click = "pavucontrol";
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          "activated" = "";
          "deactivated" = "";
        };
      };

      "custom/keyboard" = {
        exec = "${pkgs.xkb-switch}/bin/xkb-switch";
        interval = 1;
      };
      "custom/prayer-times" = {
        exec = "${pkgs.praytimes-kit}/bin/praytimes-kit next --config ${pkgs.praytimes-config}/etc/praytimes/praytimes.json";
        interval = 10;
      };
      clock = {
        format = "{:%Y-%m-%d %H:%M:%S}";
        interval = 1;
      };
      tray = {
        spacing = 10;
      };
    };
  };

  home-manager.users.ehsan.xdg.configFile."waybar/style.css".source = ./waybar-style.css;
}
