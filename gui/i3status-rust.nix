{ config, pkgs, unstable, ... }:
let
  is-laptop = (config.networking.hostName == "nixos-laptop"
    || config.networking.hostName == "nixos-old-laptop");
in {
  fonts.packages = with pkgs; [ font-awesome ];
  home-manager.users.ehsan.programs.i3status-rust = {
    package = unstable.i3status-rust;
    enable = true;
    bars = {
      bottom = {
        blocks = [
          {
            block = "music";
            format =
              " $icon {$combo.str(max_w:20,rot_interval:0.5) $prev $play $next |}";
            interface_name_exclude = [ ".*kdeconnect.*" "mpd" ];
          }

          {
            block = "net";
            format =
              "$icon $ip - {$ssid($signal_strength)|Wired connection} ^icon_net_down$speed_down.eng(prefix:K) ^icon_net_up$speed_up.eng(prefix:K)";
          }
          {
            block = "cpu";
            interval = 1;
            click = [{
              button = "left";
              cmd = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.btop}/bin/htop";
            }];
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents.eng(w:1) ";
            interval = 10;
            warning_mem = 70;
            critical_mem = 90;
          }
        ] ++ (if is-laptop then [
          {
            block = "battery";
            device = "DisplayDevice";
            driver = "upower";
            format = "$icon $percentage {$time |}";
          }
          {
            block = "backlight";
            invert_icons = true;
          }
          {
            block = "temperature";
            format = " $icon $max max ";
            format_alt = " $icon $min min, $max max, $average avg ";
            interval = 10;
          }
        ] else
          [ ]) ++ [
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
            {
              block = "custom";
              command =
                "${pkgs.praytimes-kit}/bin/praytimes-kit next --config ${pkgs.praytimes-config}/etc/praytimes/praytimes.json";
              interval = 10;
            }
            {
              block = "time";
              interval = 1;
              format = "$timestamp.datetime(f:'%F %T')";
            }
          ];
        settings = { theme = { theme = "space-villain"; }; };
        icons = "awesome5";
        theme = "gruvbox-dark";
      };
    };
  };
}
