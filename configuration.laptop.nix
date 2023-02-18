{pkgs , ...}:
{
  imports = [./common.nix];
  networking.hostName = "nixos-laptop"; # Define your hostname.

  boot.loader.grub.device="nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber=true;

}