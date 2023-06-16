{ config, pkgs, ... }: {
  imports = [ ];
  fonts.fonts = with pkgs;
    [
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
    home.file.i3Config = import ./i3-config.nix { pkgs = pkgs; };
    programs = {
      rofi = {
        enable = true;
        theme = "Adapta-Nokto";
      };
      alacritty = { enable = true; };
    };

  };
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

  ];
}
