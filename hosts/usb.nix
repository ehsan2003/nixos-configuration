{ pkgs, lib, modulesPath, disko, ... }: {
  imports = [
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/profiles/base.nix"
    ../common.nix
    disko.nixosModules.disko
  ];
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub.efiInstallAsRemovable = true;
  networking.hostName = "nixos-usb"; # Define your hostname.
  # boot.initrd.kernelModules = [ "uat" ];
  # checkout the example folder for how to configure different disko layouts

} // import ./usb-disko.nix
