{ pkgs, ... }: {
  imports = [ ./base.nix ];
  networking.hostName = "nixos-laptop"; # Define your hostname.

  services.tlp.enable = true;

}
