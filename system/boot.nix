{ unstable, pkgs, ... }: {

  boot.tmp.cleanOnBoot = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_13;
  boot.extraModulePackages = [ pkgs.linuxKernel.packages.linux_6_13.amneziawg ];

}
