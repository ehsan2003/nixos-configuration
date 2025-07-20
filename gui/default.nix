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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.windowManager.i3.enable = true; # Configure keymap in X11
  services.xserver.xkb.layout = "us,ir";
  services.xserver.xkb.options = "eurosign:e,caps:escape, grp:shifts_toggle";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  home-manager.users.ehsan = {
    gtk = {
      enable = true;
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
    };
    home.file.i3Config = import ./i3-config.nix { pkgs = pkgs; };
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
      rofi = {
        enable = true;
        theme = "Adapta-Nokto";
      };
      alacritty = { enable = true; };
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
    dmenu
    rofi
    flameshot
    i3status
    pasystray

    xarchiver
    unstable.tdesktop
  ];
}
