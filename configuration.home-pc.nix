{pkgs , ...}:
{
  imports = [./common.nix];
  networking.hostName = "nixos-home-desktop"; # Define your hostname.

  boot.loader.systemd-boot.enable = true;
  
  services.xserver.dpi = 120 ;
}