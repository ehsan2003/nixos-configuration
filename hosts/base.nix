{ ... }: {
  imports = [ ../default.nix /etc/nixos/hardware-configuration.nix ];
  home-manager.users.ehsan.programs.alacritty.settings.font.size = 12;
}
