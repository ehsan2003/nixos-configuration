{
  writeShellApplication,
  libnotify,
  sway,
  wvkbd,
  lisgd,
  rofi,
  libinput,
  coreutils,
  enable-persian ? false,
}:
writeShellApplication {
  name = "tablet-mode-monitor";
  runtimeInputs = [
    libnotify
    sway
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
      swaymsg output eDP-1 scale 1.5

      # Set bar to dock mode
      swaymsg bar bar-0 mode dock

      # Kill any existing instances first
      pkill wvkbd-mobintl 2>/dev/null || true
      pkill lisgd 2>/dev/null || true

      # Launch virtual keyboard
      ${wvkbd}/bin/wvkbd-mobintl -L 250 --landscape-layers full${
        if enable-persian then ",persian" else ""
      } &
      echo $! > /tmp/wvkbd.pid

      # Launch gesture daemon
      ${lisgd}/bin/lisgd -d /dev/input/by-path/pci-0000:00:15.0-platform-i2c_designware.0-event \
        -g "2,LR,*,*,P,swaymsg exec '${rofi}/bin/rofi -show combi' " \
        -g "2,RL,*,*,P,swaymsg exec 'pkill rofi' " \
        -g "2,DU,*,*,P,swaymsg exec 'pkill wvkbd-mobintl -SIGUSR2 '" \
        -g "2,UD,*,*,P,swaymsg exec 'pkill wvkbd-mobintl -SIGUSR1' " \
        -g "3,RL,*,*,R,swaymsg workspace prev" \
        -g "3,LR,*,*,R,swaymsg workspace next" &
      echo $! > /tmp/lisgd.pid

      echo "1" > "$STATE_FILE"
    }

    # Tablet mode exit script
    tablet_exit() {
      echo "Exiting tablet mode"
      notify-send "Tablet Mode" "Exiting tablet mode"

      # Restore scale to normal
      swaymsg output eDP-1 scale 1

      # Set bar to hide mode
      swaymsg bar bar-0 mode hide

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
    # Output format: event7   SWITCH_TOGGLE                +14.875s	switch tablet-mode state 0
    current_state=$(cat "$STATE_FILE")

    while IFS=' ' read -r event_name toggle_type timestamp _ _ new_state _ _; do
      echo "$event_name  $toggle_type  $timestamp   $new_state";
      if [ "$toggle_type" = "SWITCH_TOGGLE" ]; then
        if [ "$new_state" != "$current_state" ]; then
          if [ "$new_state" = "1" ]; then
            echo "switching to tablet mode";
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
