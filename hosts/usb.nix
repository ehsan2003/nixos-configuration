{ pkgs, lib, modulesPath, disko, ... }: {
  imports = [
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/profiles/base.nix"
    ../common.nix
    disko.nixosModules.disko
  ];

  nix.optimise.automatic = true;
  nix.optimise.dates=["12:00"];
  nix.gc.options = "--delete-older-than 7d";
  services.xserver.desktopManager.xfce.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub.efiInstallAsRemovable = true;
  networking.hostName = "nixos-usb"; # Define your hostname.
  # boot.initrd.kernelModules = [ "uat" ];
  # checkout the example folder for how to configure different disko layouts

} // import ./usb-disko.nix
