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
  services.logrotate.enable = true;
  boot.tmpOnTempfs = true;

  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "vm.vfs_cache_pressure" = 50;
    "vm.swappiness" = 10;
  };
  # boot.initrd.kernelModules = [ "uat" ];
  # checkout the example folder for how to configure different disko layouts

} // import ./usb-disko.nix
