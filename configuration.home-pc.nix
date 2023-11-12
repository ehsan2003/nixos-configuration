{ pkgs, ... }:
let dpi = 250;
in
{
  imports = [
    ./common.nix
    /etc/nixos/hardware-configuration.nix
  ];
  networking.hostName = "nixos-home-desktop"; # Define your hostname.

  home-manager.users.ehsan.home.pointerCursor = {
    x11.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 128;
  };

  home-manager.users.ehsan.programs.alacritty.settings.font.size = 12;
  services.xserver.dpi = dpi;
  home-manager.users.ehsan.programs.rofi.extraConfig."dpi" = dpi;
  console.font = pkgs.lib.mkForce "Lat2-Terminus32";
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: ${toString dpi}  
    EOF
  '';
}
