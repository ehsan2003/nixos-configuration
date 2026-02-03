{ config, pkgs, ... }:
let
  userName = config.userConfiguration.name;
in
{
  home-manager.users.${userName}.xdg.configFile = {
    "rofi/config.rasi".source = ./rofi-config.rasi;

    "rofi/theme.rasi".source = ./rofi-theme.rasi;
  };
}
