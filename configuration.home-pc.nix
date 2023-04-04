{pkgs , ...}:
{
  imports = [./common.nix];
  networking.hostName = "nixos-home-desktop"; # Define your hostname.

  boot.loader.grub.device="nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber=true;


  home-manager.users.ehsan.programs.alacritty.settings.font.size=18;
  services.xserver.dpi = 120 ;
}
