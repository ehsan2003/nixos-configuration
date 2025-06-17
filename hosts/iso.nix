{ pkgs, modulesPath, lib, ... }: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
    ../default.nix
  ];
  environment.etc.secrets = {
    enable = true;
    source = /etc/secrets.nix;
    target = "secrets.nix";
  };

  home-manager.users.ehsan.home.file.nixos-configuration = {
    source = ../.;
    target = "nixos-configuration";
  };

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  isoImage.compressImage = false;


  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems =
    lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
}
