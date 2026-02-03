{ config, hardware-configuration, ... }:
let
  userName = config.userConfiguration.name;
in
{
  imports = [ ../default.nix hardware-configuration ];
  home-manager.users.${userName}.programs.alacritty.settings.font.size = 12;
}
