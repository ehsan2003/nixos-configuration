# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
 
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${(fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz)}/nixos"
    ];

  # Use the systemd-boot EFI boot loader.
#  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.device="nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber=true;

  boot.loader.efi.canTouchEfiVariables = true;

  # Pick only one of the below networking options.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  systemd.services.clash = {
    enable = true; 
    description = "clash tunnel";
    after = ["network.target"];
    serviceConfig = {
      Restart="always";
      ExecStart="${pkgs.clash}/bin/clash -d /etc/clash";
    };
    wantedBy = ["multi-user.target"];
  };

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.windowManager.i3.enable = true;
  # Configure keymap in X11
  services.xserver.layout = "us,ir";
 services.xserver.xkbOptions = 
  "eurosign:e,caps:escape, grp:shifts_toggle";
#  "caps:escape" # map caps to escape.
# ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;

  services.xserver.displayManager.sessionCommands = "sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 94 = Shift_L' &";
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.ehsan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      thunderbird
      
    ];
  };

  home-manager.users.ehsan= { pkgs, ... }: {
    home.stateVersion = "22.11";
    home.file.i3Config = import ./i3-config.nix {pkgs = pkgs;};
    programs.bash.enable = true;
  };
  environment.shells = with pkgs; [ zsh ]; 
  # List packages installed in system profile. To search, run:

  # $ nix search wget
   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     curl
     tdesktop
     nodejs
     yarn
     neovim
     qv2ray
     chromium
     python39
     git
     aria2
     rofi
     clash
     patchelf
     xorg.xmodmap
     libnotify
     dunst 
     translate-shell
     xsel
     dunst
     rofi
     flameshot
     i3status
     nitrogen
     tor-browser-bundle-bin
     killall 
     htop
     helix
  ];
  virtualisation.docker.enable = true;
  programs.zsh.enable = true; 
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" "vi-mode" ];
    theme = "robbyrussell";
  }; 
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
