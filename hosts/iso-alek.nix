{ pkgs, modulesPath, lib, ... }: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
    ../common.nix
  ];
  environment.etc.secrets = {
    enable = true;
    source = /etc/secrets.json;
    target = "secrets.json";
  };

  home-manager.users.ehsan.home.file.nixos-configuration = {
    source = ../.;
    target = "nixos-configuration";
  };

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  isoImage.compressImage = false;
  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.xserver.displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --rate 60 &";
  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems =
    lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
}
