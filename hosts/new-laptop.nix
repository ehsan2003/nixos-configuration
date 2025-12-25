{ pkgs, ... }:
let dpi = 120;
in {
  imports = [ ./base.nix ];
  networking.hostName = "nixos-new-laptop"; # Define your hostname.
  services.xserver.dpi = dpi;
  home-manager.users.ehsan.programs.rofi.extraConfig."dpi" = dpi;
  services.xserver.displayManager.sessionCommands = ''
        sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 94 = Shift_L' &
        ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
          Xft.dpi: ${toString dpi}  
        EOF
  '';

  services.tlp.enable = true;
}

