{ config, pkgs, ... }:

{
  home-manager.users.ehsan.xdg.configFile = {
    "rofi/config.rasi".source = ./rofi-config.rasi;

    "rofi/theme.rasi".source = ./rofi-theme.rasi;
  };
}
