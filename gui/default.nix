{ pkgs, unstable, ... }: {
  imports = [ ./i3status-rust.nix ./firefox.nix ./media.nix ];
  fonts.packages = with pkgs; [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fira-code
    vazir-code-font
  ];
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable Sway (Wayland)
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = ["--my-next-gpu-wont-be-nvidia"];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  # Display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.disableWhileTyping = true;

  home-manager.users.ehsan = {
    gtk = {
      enable = true;
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
    };
    home.file.".config/sway/config".text = (import ./sway-config.nix { pkgs = pkgs; }).text;
    home.file.aiderConfig = {
      target = ".config/aichat/config.yaml";
      text = ''
        vim: true
        model: openrouter:deepseek/deepseek-r1:free
        clients:
          - type: openai-compatible
            name: openrouter
            api_base: https://openrouter.ai/api/v1
            api_key: null
            extra:
              proxy: socks5://127.0.0.1:1080
      '';
    };
    services.dunst.enable = true;
    programs = {
      wofi = {
        enable = true;
      };
      alacritty = { enable = true; };
    };

  };
  # services.gammastep.enable = true;
  environment.systemPackages = with pkgs; [
    alacritty
    # Window manager and utils
    wofi
    libnotify
    dunst
    translate-shell
    wl-clipboard
    grim
    swappy
    i3status
    scrcpy
    libreoffice

    xarchiver
    unstable.telegram-desktop
    sway
    swayidle
    swaylock
    waybar
  ];
}
