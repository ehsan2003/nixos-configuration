{ pkgs, ... }:
let dpi = 120;
in {
  imports = [ ./base.nix ];
  networking.hostName = "nixos-laptop"; # Define your hostname.
  services.xserver.dpi = dpi;
  home-manager.users.ehsan.programs.rofi.extraConfig."dpi" = dpi;
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: ${toString dpi}  
    EOF
  '';

  services.tlp.enable = true;

  environment.systemPackages = [ pkgs.quartus-prime-lite ];

}
