{pkgs , ...}:
{
  imports = [./common.nix];
  networking.hostName = "nixos-laptop"; # Define your hostname.

  boot.loader.grub.device="nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber=true;

  services.xserver.displayManager.sessionCommands = "sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 94 = Shift_L' &";
  home-manager.users.ehsan.programs.alacritty.settings.font.size=12;

}
