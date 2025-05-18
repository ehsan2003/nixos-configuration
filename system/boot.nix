{ unstable, ... }: {

  boot.tmp.cleanOnBoot = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = unstable.linuxKernel.packages.linux_6_12;
  boot.extraModulePackages =
    [ unstable.linuxKernel.packages.linux_6_12.amneziawg ];

}
