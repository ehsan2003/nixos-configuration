{ pkgs, ... }: {
  imports = [ ./common.nix ];
  networking.hostName = "nixos-laptop"; # Define your hostname.

  services.xserver.displayManager.sessionCommands =
    "sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 94 = Shift_L' &";
  home-manager.users.ehsan.programs.alacritty.settings.font.size = 12;

}
