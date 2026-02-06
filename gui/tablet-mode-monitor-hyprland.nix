{
  writeShellApplication,
  libnotify,
  hyprland,
  wvkbd,
  lisgd,
  rofi,
  libinput,
  coreutils,
  hyprpaper,
  enable-persian ? false,
}:
writeShellApplication {
  name = "tablet-mode-monitor-hyprland";
  runtimeInputs = [
    libnotify
    hyprland
    libinput
    coreutils
  ];
  text = ''
    DEVICE="/dev/input/by-path/platform-INTC1078:00-event"
    STATE_FILE="/tmp/tablet_mode_state"

    # Initialize state file
    if [ ! -f "$STATE_FILE" ]; then
      echo "0" > "$STATE_FILE"
    fi

    # Tablet mode enter script
    tablet_enter() {
      echo "Entering tablet mode"
      notify-send "Tablet Mode" "Entering tablet mode"

      # Set scale to 1.5
      hyprctl keyword monitor "eDP-1,preferred,auto,1.5"

      # Launch virtual keyboard
      pkill wvkbd-mobintl 2>/dev/null || true
      pkill lisgd 2>/dev/null || true

      ${wvkbd}/bin/wvkbd-mobintl -L 250 --landscape-layers full${
        if enable-persian then ",persian" else ""
      } &
      echo $! > /tmp/wvkbd.pid

      # Launch gesture daemon
      ${lisgd}/bin/lisgd -d /dev/input/by-path/pci-0000:00:15.0-platform-i2c_designware.0-event \
        -g "2,LR,*,*,P,hyprctl dispatch exec '${rofi}/bin/rofi -show combi' " \
        -g "2,RL,*,*,P,hyprctl dispatch exec 'pkill rofi' " \
        -g "2,DU,*,*,P,hyprctl dispatch exec 'pkill wvkbd-mobintl -SIGUSR2 '" \
        -g "2,UD,*,*,P,hyprctl dispatch exec 'pkill wvkbd-mobintl -SIGUSR1' " \
        -g "3,RL,*,*,R,hyprctl dispatch workspace e-1" \
        -g "3,LR,*,*,R,hyprctl dispatch workspace e+1" &
      echo $! > /tmp/lisgd.pid

      echo "1" > "$STATE_FILE"
    }

    # Tablet mode exit script
    tablet_exit() {
      echo "Exiting tablet mode"
      notify-send "Tablet Mode" "Exiting tablet mode"

      # Restore scale to normal
      hyprctl keyword monitor "eDP-1,preferred,auto,1"

      # Kill virtual keyboard
      if [ -f /tmp/wvkbd.pid ]; then
        kill "$(cat /tmp/wvkbd.pid)" 2>/dev/null || true
        rm /tmp/wvkbd.pid
      fi
      pkill wvkbd-mobintl 2>/dev/null || true

      # Kill gesture daemon
      if [ -f /tmp/lisgd.pid ]; then
        kill "$(cat /tmp/lisgd.pid)" 2>/dev/null || true
        rm /tmp/lisgd.pid
      fi
      pkill lisgd 2>/dev/null || true

      echo "0" > "$STATE_FILE"
    }

    # Monitor events using libinput debug-events
    current_state=$(cat "$STATE_FILE")

    while IFS=' ' read -r _ toggle_type _ _ _ new_state _ _; do
      if [ "$toggle_type" = "SWITCH_TOGGLE" ]; then
        if [ "$new_state" != "$current_state" ]; then
          if [ "$new_state" = "1" ]; then
            echo "switching to tablet mode"
            tablet_enter
          else
            echo "switching to normal mode"
            tablet_exit
          fi
          current_state="$new_state"
        fi
      fi
    done < <(stdbuf -o0 libinput debug-events "$DEVICE")
  '';
}
