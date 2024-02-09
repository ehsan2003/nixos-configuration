{ config, nixpkgs, pkgs, unstable_input, nur, secrets, ... }: {
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
  users.users.noob = {
    hashedPassword =
      "$y$j9T$1lhUWp7X8XkYRnaj1gQZ./$kowb2rHIy3IxBRBUU5Cxgi8kLDeEJCRh9qWFCJlPQ82"; # noob
    isNormalUser = true;
    extraGroups = [ "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.ehsan = {
    nixpkgs.overlays = [ (self: super: { fcitx-engines = pkgs.fcitx5; }) ];
    home.stateVersion = "22.11";
  };
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import nur {
      inherit pkgs;
      nurpkgs = pkgs;
    };
  };
  environment.systemPackages = [ pkgs.linux-wifi-hotspot pkgs.ollama ];

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  services.atd.enable = true;
  systemd.user.services.ollama = {
    environment = { https_proxy = "http://localhost:1081"; };
    enable = true;
    description = "ollama server";
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.ollama}/bin/ollama serve";
    };
    wantedBy = [ "multi-user.target" ];
  };
  services.openssh.enable = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };
  location = {
    longitude = secrets.location.longitude;
    latitude = secrets.location.latitude;
  };
  environment.variables.OPENAI_API_KEY = secrets.OPENAI_API_KEY;
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
