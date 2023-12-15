{ pkgs, lib, ... }: {
  imports = [ ./base.nix ];
  networking.hostName = "nixos-usb"; # Define your hostname.
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
}
