{ config, pkgs, ... }:
let
  dpi = 250;
  userName = config.userConfiguration.name;
in {
  home-manager.users.${userName}.home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 128;
  };

  console.font = pkgs.lib.mkForce "Lat2-Terminus32";
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };

}
