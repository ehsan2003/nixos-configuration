{ hardware-configuration, ... }: {
  imports = [ ../default.nix hardware-configuration ];
  home-manager.users.ehsan.programs.alacritty.settings.font.size = 12;
}
