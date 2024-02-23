{ config, nixpkgs, pkgs, unstable_input, secrets, ... }: {
  imports = [ ./boot.nix ./users.nix ./nix.nix ./network.nix ];


  time.timeZone = "Asia/Tehran";

  services.openssh.enable = true;
  environment.systemPackages = [ pkgs.linux-wifi-hotspot pkgs.ollama ];

  location = {
    longitude = secrets.location.longitude;
    latitude = secrets.location.latitude;
  };
}
