{ config, nixpkgs, pkgs, unstable_input, secrets, ... }: {
  imports = [ ./boot.nix ./users.nix ./nix.nix ./network.nix ];

  time.timeZone = "Asia/Tehran";

  services.openssh.enable = true;
  environment.systemPackages = [ pkgs.linux-wifi-hotspot pkgs.ollama ];
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      enable = true;
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  security.polkit.enable = true;
  services.ollama.enable = true;
  services.ollama.acceleration = "rocm";
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  location = {
    longitude = secrets.location.longitude;
    latitude = secrets.location.latitude;
  };
}
