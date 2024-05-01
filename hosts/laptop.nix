{ pkgs, ... }: {
  imports = [ ./base.nix ];
  networking.hostName = "nixos-laptop"; # Define your hostname.

  services.xserver.displayManager.sessionCommands =
    "sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 94 = Shift_L' &";
  services.tlp.enable = true;

  home-manager.users.ehsan.programs.taskwarrior.config = {
    sync.server.origin = "http://192.168.1.105:8443";
    sync.server.client_id = "7a6d0223-1ea0-46d0-a507-c36c2bcd2df7";
  };

}
