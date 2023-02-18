{pkgs , ...}:
{
  imports = [./common.nix];
  networking.hostName = "nixos-laptop"; # Define your hostname.
}