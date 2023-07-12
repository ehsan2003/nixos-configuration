{ config, pkgs, ... }: {
  imports = [ ];

  # Use the systemd-boot EFI boot loader.
  boot.tmp.cleanOnBoot = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  time.timeZone = "Asia/Tehran";

  users.users.ehsan = {
    hashedPassword =
      "$y$j9T$2nOFoeEIw1pVXxpVrAvNb1$LRGyoksEO8Z8G36xU4d3Jdm8BIm9hYfmWZpK8SQQK3D"; # ehsan
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.ehsan = {
    nixpkgs.overlays = [ (self: super: { fcitx-engines = pkgs.fcitx5; }) ];
    home.stateVersion = "22.11";
  };
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [ "discord" ];
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };
  environment.systemPackages = [
    (import ./lib/setup.nix { inherit pkgs; })
    (import ./lib/restore.nix { inherit pkgs; })
    (import ./lib/backup.nix { inherit pkgs; })
    pkgs.linux-wifi-hotspot
  ];

  boot.extraModulePackages = with config.boot.kernelPackages;
    [ v4l2loopback.out ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';

  services.openssh.enable = true;
  programs.mosh.enable = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

}
