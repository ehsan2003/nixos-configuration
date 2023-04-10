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
  boot.cleanTmpDir = true ;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://localhost:1080";
  services.openvpn.servers = {
    vpn  = { 
      autoStart = false;
      config = '' config /etc/openvpn/client.conf ''; 
      updateResolvConf= true;
    };
  };
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  systemd.services.xray = {
    enable = true; 
    description = "xray core";
    after = ["network.target"];
    serviceConfig = {
      Restart="always";
      ExecStart="${pkgs.xray}/bin/xray run -config /etc/xray/config.json";
    };
    wantedBy = ["multi-user.target"];
  };
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
  services.xserver.xkbOptions = "eurosign:e,caps:escape, grp:shifts_toggle";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;

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

  home-manager.users.ehsan =  {
    home.shellAliases = {
      v = "nvim";
    };
    home.stateVersion = "22.11";
    home.file.i3Config = import ./i3-config.nix {pkgs = pkgs;};
    home.file.astroNvim = {
      enable =  true; 
      source = (fetchGit {url ="https://github.com/AstroNvim/AstroNvim";}).outPath;
      target = ".config/nvim";
    };
    home.file.astroNvimConfig = {
      enable =  true; 
      text = builtins.readFile ./astronvim.init.lua;
      target = ".config/astronvim/lua/user/init.lua";
    };
    
    programs = {
      bash.enable = true ;      
      
      helix = {
        enable = true ;
        settings = {
          theme = "tokyonight" ;
        };
      };      
      
      rofi = {
        enable = true ;
        theme = "Adapta-Nokto" ;
      };
      alacritty = {
        enable = true; 
      };
      git = {
        enable = true ;
        userName = "ehsan" ;
        userEmail = "ehsan2003.2003.382@gmail.com";
      };
                 
    };
    
  };
  nix.settings.experimental-features = "nix-command flakes";
  environment.shells = with pkgs; [ zsh ]; 
  # List packages installed in system profile. To search, run:
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "discord"
    ];
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     # editors
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     helix
     neovim

     # Netowrk
     wget
     curl
     aria2
     clash
     openvpn
     xray

     # Programming
     nodejs
     yarn
     python39
     git
     gcc
     cargo
     rustc
     deno
     rust-analyzer
     nil
     nixfmt
     rustfmt



     alacritty
     # Window manager and utils
     rofi
     xorg.xmodmap
     libnotify
     dunst 
     translate-shell
     xsel
     dunst
     rofi
     flameshot
     i3status
    
     # Absolute Utils
     killall 
     htop
     unzip
     ripgrep
     jcal
     xarchiver

    
     # Sane Applications
     discord
     tdesktop
     chromium
     tor-browser-bundle-bin

     # media stuff
     obs-studio
     ffmpeg
     vlc 
     smplayer
     mplayer
    
  ];
  virtualisation.docker.enable = true;
  programs.zsh.enable = true; 
  programs.zsh.shellAliases = {
    v = "nvim";
  };
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
