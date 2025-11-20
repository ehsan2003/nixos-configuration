{ ... }: {
  imports = [
    ../default.nix
    (if builtins.getEnv "INSTALLING" == "1" then
      /mnt/etc/nixos/hardware-configuration.nix
    else
      /etc/nixos/hardware-configuration.nix)
  ];
  home-manager.users.ehsan.programs.alacritty.settings.font.size = 12;
}
