{ pkgs, ... }: {
  imports = [ ./common.nix ];
  networking.hostName = "nixos-home-desktop"; # Define your hostname.

  home-manager.users.ehsan.programs.alacritty.settings.font.size = 18;
  services.xserver.dpi = 120;
}
