{ pkgs, modulesPath, lib, ... }: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
    ./common.nix
  ];

  environment.etc.proxy = {
    enable =  true;
    mode = "0755";
    source = /etc/proxy/main.sh;
    target="proxy/main.sh";
  };
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  isoImage.compressImage = false;
  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems =
    lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
}
