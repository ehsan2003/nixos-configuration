{ pkgs, ... }: {
  imports = [ ./base.nix ];
  networking.hostName = "nixos-old-laptop"; # Define your hostname.

  services.xserver.displayManager.sessionCommands =
    "sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 94 = Shift_L' &";
  services.tlp.enable = true;

}
