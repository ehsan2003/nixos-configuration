{ pkgs, lib, modulesPath, disko, ... }:
{
  imports = [
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/profiles/base.nix"
    ../default.nix
    disko.nixosModules.disko
  ];

  # nix.optimise.automatic = true;
  # nix.optimise.dates=["12:00"];
  nix.gc.options = lib.mkForce "--delete-older-than 7d";
  boot.loader.grub.useOSProber = lib.mkForce false;
  services.xserver.desktopManager.xfce.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub.efiInstallAsRemovable = true;
  networking.hostName = "nixos-usb"; # Define your hostname.
  environment.systemPackages = [ pkgs.xfce.thunar ];
  # boot.initrd.kernelModules = [ "uat" ];
  # checkout the example folder for how to configure different disko layouts

} // import ./usb-disko.nix
