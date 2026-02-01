{ pkgs, config, ... }:
let
  is-tab = (
    config.networking.hostName == "nixos-new-laptop"
  );
  notitrans-fa = pkgs.callPackage ./notitrans-fa.nix { };
  notitrans-en = pkgs.callPackage ./notitrans-en.nix { };
  notitrans-dict = pkgs.callPackage ./notitrans-dict.nix { };
  search-select = pkgs.callPackage ./search-select.nix { };
  aiask = pkgs.callPackage ./aiask.nix { };
  ensure-class = pkgs.callPackage ./ensure-class.nix { };
  tablet-mode-monitor = pkgs.callPackage ./tablet-mode-monitor.nix { };
in
{
  target = ".config/sway/config";
  text = ''
    # Sway config file (derived from i3)
    # Please see https://github.com/sway/sway for complete reference!

    set $mod Mod4

    # Font for window titles. Will also be used by the bar unless a different font
    # is used in the bar {} block below.
    font pango:monospace 8

    # This font is widely installed, provides lots of unicode glyphs, right-to-left
    # text rendering and scalability on retina/hidpi displays (thanks to pango).
    #font pango:DejaVu Sans Mono 8

    # Auto-start applications
    # Note: sway doesn't use dex, use exec directly for autostart

    # Lock screen before suspend
    exec swaylock -f

    # NetworkManager applet
    exec --no-startup-id ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator

    # Use pactl to adjust volume in PulseAudio.
    set $refresh_i3status killall -SIGUSR1 i3status
    bindsym XF86MonBrightnessUp exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%
    bindsym XF86MonBrightnessDown exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
    bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
    bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
    bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
    bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

    # Use Mouse+$mod to drag floating windows to their wanted position
    floating_modifier $mod

    # start a terminal
    bindsym $mod+Return exec alacritty

    # kill focused window
    bindsym $mod+Shift+q kill

    # start application launcher (wofi for Wayland)

    bindsym $mod+d exec --no-startup-id rofi -show combi
    bindsym $mod+n exec --no-startup-id rofi -show 

    # change focus
    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right

    # alternatively, you can use the cursor keys:
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    # move focused window
    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right

    # alternatively, you can use the cursor keys:
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right

    # split in horizontal orientation
    bindsym $mod+o split h

    # split in vertical orientation
    bindsym $mod+v split v

    # enter fullscreen mode for the focused container
    bindsym $mod+f fullscreen toggle

    # change container layout (stacked, tabbed, toggle split)
    # bindsym $mod+b exec --no-startup-id "${ensure-class}/bin/ensure-class btop \"alacritty --class btop,btop -o font.size=8 -e btop\"";
    # bindsym $mod+s exec --no-startup-id "${ensure-class}/bin/ensure-class ai \"firefox https://duck.ai --class ai \" ;exec \"sleep 0.1; swaymsg scratchpad show\";
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # toggle tiling / floating
    bindsym $mod+Shift+z floating toggle

    # change focus between tiling / floating windows
    bindsym $mod+z focus mode_toggle

    # focus the parent container
    bindsym $mod+a focus parent

    # focus the child container
    #bindsym $mod+d focus child

    # Define names for default workspaces for which we configure key bindings later on.
    # We use variables to avoid repeating the names in multiple places.
    set $ws1 "1"
    set $ws2 "2"
    set $ws3 "3"
    set $ws4 "4"
    set $ws5 "5"
    set $ws6 "6"
    set $ws7 "7"
    set $ws8 "8"
    set $ws9 "9"
    set $ws10 "10"

    # switch to workspace
    bindsym $mod+1 workspace number $ws1; exec "${ensure-class}/bin/ensure-class glrnvim glrnvim"
    bindsym $mod+2 workspace number $ws2; exec ${ensure-class}/bin/ensure-class firefox "firefox"
    bindsym $mod+3 workspace number $ws3; exec "${ensure-class}/bin/ensure-class Alacritty alacritty"
    bindsym $mod+4 workspace number $ws4; exec ${ensure-class}/bin/ensure-class aider "alacritty --class=aider"
    bindsym $mod+5 workspace number $ws5; exec "${ensure-class}/bin/ensure-class org.telegram.desktop Telegram"
    bindsym $mod+6 workspace number $ws6
    bindsym $mod+7 workspace number $ws7
    bindsym $mod+8 workspace number $ws8
    bindsym $mod+9 workspace number $ws9
    bindsym $mod+0 workspace number $ws10

    # move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace number $ws1
    bindsym $mod+Shift+2 move container to workspace number $ws2
    bindsym $mod+Shift+3 move container to workspace number $ws3
    bindsym $mod+Shift+4 move container to workspace number $ws4
    bindsym $mod+Shift+5 move container to workspace number $ws5
    bindsym $mod+Shift+6 move container to workspace number $ws6
    bindsym $mod+Shift+7 move container to workspace number $ws7
    bindsym $mod+Shift+8 move container to workspace number $ws8
    bindsym $mod+Shift+9 move container to workspace number $ws9
    bindsym $mod+Shift+0 move container to workspace number $ws10

    # reload the configuration file
    bindsym $mod+Shift+c reload
    # restart sway inplace (preserves your layout/session, can be used to upgrade sway)
    bindsym $mod+Shift+r restart
    # exit sway (logs you out of your Wayland session)
    bindsym $mod+Shift+e exec "swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'"

    # resize window (you can also use the mouse for that)
    mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window's width.
        # Pressing right will grow the window's width.
        # Pressing up will shrink the window's height.
        # Pressing down will grow the window's height.
        bindsym h resize shrink width 10 px or 10 ppt
        bindsym j resize grow height 10 px or 10 ppt
        bindsym k resize shrink height 10 px or 10 ppt
        bindsym l resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: enter or escape or $mod+r
        bindsym return mode "default"
        bindsym escape mode "default"
        bindsym $mod+r mode "default"
    }

    bindsym $mod+r mode "resize"

    # Start swaybar to display a workspace bar
    bar {
      swaybar_command waybar
      position top
      hidden_state hide
      mode hide
      modifier Mod4
    }

    hide_edge_borders smart

    workspace_layout default
    gaps inner 5
    gaps outer 5
    smart_gaps on

    # Screenshot with grim
    bindsym Print exec "${pkgs.swappy}/bin/swappy-grim &"

    bindsym $mod+t exec "${notitrans-fa}/bin/notitrans-fa"
    bindsym $mod+i exec "${aiask}/bin/aiask"
    bindsym $mod+y exec "${notitrans-en}/bin/notitrans-en"
    bindsym $mod+g exec "${search-select}/bin/search-select"
    bindsym $mod+x exec "${notitrans-dict}/bin/notitrans-dict"

    bindsym $mod+c exec "${pkgs.dunst}/bin/dunstctl history-pop"

    exec --no-startup-id "${pkgs.blueman}/bin/blueman-applet"
    exec --no-startup-id "${pkgs.dunst}/bin/dunst"

    ${
      if is-tab then
        ''

          # Tablet mode monitor
          exec --no-startup-id "${tablet-mode-monitor}/bin/tablet-mode-monitor
          "''
      else
        ""
    }

    # exec --no-startup-id alacritty --class btop,btop -o font.size=8 -e btop
    # exec --no-startup-id firefox https://duck.ai --class ai
    for_window [app_id="glrnvim"] move to workspace 1, workspace number 1
    for_window [app_id="firefox"] move to workspace 2, workspace number 2
    for_window [app_id="Alacritty"] move to workspace 3, workspace number 3
    for_window [app_id="aider"] move to workspace 4, workspace number 4
    for_window [app_id="Telegram"] move to workspace 5, workspace number 5
    # for_window [app_id="btop"] move scratchpad;
    # for_window [app_id="ai"] move scratchpad;

    for_window [app_id="^.*"] border pixel 1

    # Input configuration (replaces xmodmap)
    input type:keyboard {
        xkb_layout us,ir
        xkb_options eurosign:e,caps:escape,grp:shifts_toggle
    }

    input type:touchpad {
        tap enabled
        dwt enabled
        middle_emulation enabled
    }

    # Output configuration for HiDPI (example, adjust as needed)
    # output eDP-1 scale 2

    # Use the Wayland native backend for Firefox
    # Set environment variables in sway config or systemd user session
  '';
}
