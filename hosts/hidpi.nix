{ pkgs }:
let dpi = 250;
in {
  home-manager.users.ehsan.home.pointerCursor = {
    x11.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 128;
  };

  services.xserver.dpi = dpi;
  home-manager.users.ehsan.programs.rofi.extraConfig."dpi" = dpi;
  console.font = pkgs.lib.mkForce "Lat2-Terminus32";
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: ${toString dpi}  
    EOF
  '';

}
