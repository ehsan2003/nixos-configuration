{ pkgs, config, ... }:
let
  is-tab = (config.networking.hostName == "nixos-new-laptop");
  notitrans-fa = pkgs.callPackage ./notitrans-fa.nix { };
  notitrans-en = pkgs.callPackage ./notitrans-en.nix { };
  notitrans-dict = pkgs.callPackage ./notitrans-dict.nix { };
  search-select = pkgs.callPackage ./search-select.nix { };
  ensure-class = pkgs.callPackage ./ensure-class-hyprland.nix { };
  tablet-mode-monitor = pkgs.callPackage ./tablet-mode-monitor-hyprland.nix {
    enable-persian = config.userConfiguration.persianLayout;
  };
in
{
  target = ".config/hypr/hyprland.conf";
  text = ''
    # Hyprland config - migrated from Sway
    # Keybindings and features preserved from Sway config

    ################
    ### MONITORS ###
    ################

    # Will be configured automatically or via hardware-configuration
    monitor =,preferred,auto,auto


    #################
    ### AUTOSTART ###
    #################

    # NetworkManager applet
    exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator

    # Bluetooth
    exec-once = ${pkgs.blueman}/bin/blueman-applet

    # Notifications
    exec-once = ${pkgs.dunst}/bin/dunst

    # Background
    exec-once = ${pkgs.hyprpaper}/bin/hyprpaper

    # Waybar with Hyprland-specific config
    exec-once = ${pkgs.waybar}/bin/waybar -c ~/.config/waybar-hyprland/config && pkill -SIGUSR1 .waybar-wrapped

    ${
      if is-tab then
        ''
          # Tablet mode monitor
          exec-once = ${tablet-mode-monitor}/bin/tablet-mode-monitor
        ''
      else
        ""
    }


    #####################
    ### LOOK AND FEEL ###
    #####################

    general {
        gaps_in = 5
        gaps_out = 5
        border_size = 1

        # https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false

        # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
        allow_tearing = false

        layout = dwindle
    }

    decoration {
        rounding = 0
        blur {
            enabled = false
        }
        shadow {
            enabled = false
        }
    }

    animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    dwindle {
        pseudotile = false
        preserve_split = true
    }

    master {
        new_status = slave
    }

    misc {
        force_default_wallpaper = 0
        disable_hyprland_logo = true
        enable_swallow = true
        swallow_regex = ^(Alacritty|kitty)$
    }


    #############
    ### INPUT ###
    #############

    input {
        kb_layout = us${if config.userConfiguration.persianLayout then ",ir" else ""}
        kb_options = eurosign:e,caps:escape,grp:shifts_toggle

        follow_mouse = 1

        sensitivity = 0

        touchpad {
            natural_scroll = false
            tap-to-click = true
            disable_while_typing = true
            tap_button_map = lmr
            middle_button_emulation = true
        }
    }


    ###################
    ### KEYBINDINGS ###
    ###################

    # $mod = Mod4 (Super/Windows key)


    bindt = , Super_L, exec, pkill -SIGUSR1 .waybar-wrapped
    bindrt = SUPER, Super_L, exec, pkill -SIGUSR1 .waybar-wrapped

    # Terminal
    bind = SUPER, Return, exec, alacritty

    # Kill focused window
    bind = SUPER SHIFT, Q, killactive,

    # Application launcher
    bind = SUPER, D, exec, rofi -show combi
    bind = SUPER, N, exec, rofi -show

    # Move focus with vim keys
    bind = SUPER, H, movefocus, l
    bind = SUPER, L, movefocus, r
    bind = SUPER, K, movefocus, u
    bind = SUPER, J, movefocus, d

    # Move focus with arrow keys
    bind = SUPER, Left, movefocus, l
    bind = SUPER, Right, movefocus, r
    bind = SUPER, Up, movefocus, u
    bind = SUPER, Down, movefocus, d

    # Move windows with vim keys
    bind = SUPER SHIFT, H, movewindow, l
    bind = SUPER SHIFT, L, movewindow, r
    bind = SUPER SHIFT, K, movewindow, u
    bind = SUPER SHIFT, J, movewindow, d

    # Move windows with arrow keys
    bind = SUPER SHIFT, Left, movewindow, l
    bind = SUPER SHIFT, Right, movewindow, r
    bind = SUPER SHIFT, Up, movewindow, u
    bind = SUPER SHIFT, Down, movewindow, d

    # Split orientation
    bind = SUPER, O, togglesplit,
    bind = SUPER, V, togglesplit,

    # Fullscreen
    bind = SUPER, F, fullscreen,

    # Layouts
    bind = SUPER, W, togglegroup,
    bind = SUPER, E, togglesplit,

    # Toggle floating
    bind = SUPER SHIFT, Z, togglefloating,

    # Focus toggle (tiling/floating)
    bind = SUPER, Z, cyclenext,

    # Focus parent
    # Note: Hyprland doesn't have parent/child like i3/sway
    bind = SUPER, A, focusurgentorlast

    # Resize mode
    bind = SUPER, R, submap, resize

    # Lock screen
    bindel = SUPER SHIFT, M, exec, ${pkgs.swaylock}/bin/swaylock -f --image ~/.background-image

    # Reload/Restart/Exit
    bind = SUPER SHIFT, C, exec, hyprctl reload
    bind = SUPER SHIFT, R, exec, systemctl restart --user hyprland
    bind = SUPER SHIFT, E, exec, wlogout --protocol layer-shell

    # Workspace switching (with ensure-class)
    bind = SUPER, 1, exec, hyprctl dispatch workspace 1 && ${ensure-class}/bin/ensure-class-hyprland glrnvim glrnvim
    bind = SUPER, 2, exec, hyprctl dispatch workspace 2 && ${ensure-class}/bin/ensure-class-hyprland firefox firefox
    bind = SUPER, 3, exec, hyprctl dispatch workspace 3 && ${ensure-class}/bin/ensure-class-hyprland Alacritty alacritty
    bind = SUPER, 4, exec, hyprctl dispatch workspace 4 && ${ensure-class}/bin/ensure-class-hyprland aider "alacritty --class=aider"
    bind = SUPER, 5, exec, hyprctl dispatch workspace 5 && ${ensure-class}/bin/ensure-class-hyprland org.telegram.desktop Telegram
    bind = SUPER, 6, workspace, 6
    bind = SUPER, 7, workspace, 7
    bind = SUPER, 8, workspace, 8
    bind = SUPER, 9, workspace, 9
    bind = SUPER, 0, workspace, 10

    # Move to workspace
    bind = SUPER SHIFT, 1, movetoworkspace, 1
    bind = SUPER SHIFT, 2, movetoworkspace, 2
    bind = SUPER SHIFT, 3, movetoworkspace, 3
    bind = SUPER SHIFT, 4, movetoworkspace, 4
    bind = SUPER SHIFT, 5, movetoworkspace, 5
    bind = SUPER SHIFT, 6, movetoworkspace, 6
    bind = SUPER SHIFT, 7, movetoworkspace, 7
    bind = SUPER SHIFT, 8, movetoworkspace, 8
    bind = SUPER SHIFT, 9, movetoworkspace, 9
    bind = SUPER SHIFT, 0, movetoworkspace, 10

    # Media keys - use bindel for single-trigger events
    bindel = , XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%
    bindel = , XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
    bindel = , XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +10%
    bindel = , XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -10%
    bindel = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle
    bindel = , XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle

    # Screenshot
    bind = , Print, exec, ${pkgs.flameshot}/bin/flameshot gui

    # Custom scripts
    bind = SUPER, T, exec, ${notitrans-fa}/bin/notitrans-fa
    bind = SUPER, Y, exec, ${notitrans-en}/bin/notitrans-en
    bind = SUPER, G, exec, ${search-select}/bin/search-select
    bind = SUPER, X, exec, ${notitrans-dict}/bin/notitrans-dict
    bind = SUPER, C, exec, ${pkgs.dunst}/bin/dunstctl history-pop

    # Scroll through existing workspaces with mod+scroll
    bind = SUPER, mouse_down, workspace, e+1
    bind = SUPER, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = SUPER, mouse:272, movewindow
    bindm = SUPER, mouse:273, resizewindow


    ###################
    ### RESIZE SUBMAP ###
    ###################

    submap = resize
    binde = , H, resizeactive, -10 0
    binde = , L, resizeactive, 10 0
    binde = , K, resizeactive, 0 -10
    binde = , J, resizeactive, 0 10
    binde = , Left, resizeactive, -10 0
    binde = , Right, resizeactive, 10 0
    binde = , Up, resizeactive, 0 -10
    binde = , Down, resizeactive, 0 10
    bind = , escape, submap, reset
    bind = , return, submap, reset
    bind = SUPER, R, submap, reset
    submap = reset


    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################

    # Workspace assignments
    windowrulev2 = workspace 1, class:^(glrnvim)$
    windowrulev2 = workspace 2, class:^(firefox)$
    windowrulev2 = workspace 3, class:^(Alacritty)$
    windowrulev2 = workspace 4, class:^(aider)$
    windowrulev2 = workspace 5, class:^(org.telegram.desktop)$
    windowrulev2 = workspace 5, class:^(TelegramDesktop)$

    # Border size for all windows
    windowrulev2 = bordersize 1, class:.*

    # Ignore maximize requests from apps
    windowrule = suppressevent maximize, class:.*

    # Fix some dragging issues with XWayland
    windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0


    #########################
    ### XWAYLAND ###
    #########################

    xwayland {
        use_nearest_neighbor = false
    }


    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################

    env = XCURSOR_SIZE,24
    env = HYPRCURSOR_SIZE,24
    env = GDK_SCALE,1
    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland
    env = MOZ_ENABLE_WAYLAND,1
    env = QT_QPA_PLATFORM,wayland
  '';
}
