{ pkgs, lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-x86_64.nix")
    ../common.nix
  ];
  networking.hostName = "nixos-usb"; # Define your hostname.
  sdImage.compressImage = false;
  sdImage.firmwareSize = 500;
}
