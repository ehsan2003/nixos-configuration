{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { };
in {
  imports = [ ];

  # Use the systemd-boot EFI boot loader.
  boot.tmp.cleanOnBoot = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.
  
  # Set your time zone.
  time.timeZone = "Asia/Tehran";

    # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ehsan = {
    hashedPassword = "$y$j9T$2nOFoeEIw1pVXxpVrAvNb1$LRGyoksEO8Z8G36xU4d3Jdm8BIm9hYfmWZpK8SQQK3D";
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      thunderbird

    ];
  };

  home-manager.users.ehsan = {
    nixpkgs.overlays = [ (self: super: { fcitx-engines = pkgs.fcitx5; }) ];
    home.shellAliases = { v = "nvim"; };
    home.stateVersion = "22.11";
 };
  nix.settings.experimental-features = "nix-command flakes";
  # List packages installed in system profile. To search, run:
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [ "discord" ];
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Sane Applications
    discord
    unstable.tdesktop
    chromium
    tor-browser-bundle-bin
  ];
  
  services.openssh.enable = true;
  programs.mosh.enable = true;
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
}
