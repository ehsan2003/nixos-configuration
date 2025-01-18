{ pkgs, unstable, ... }:
let dpi = 250;
in {
  imports = [ ./base.nix ./hidpi.nix ];
  networking.hostName = "nixos-home-desktop"; # Define your hostname.

  services.serviio.enable = true;
  systemd.services.task-sync = {
    enable = true;
    description = "taskwarrior sync server";
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart =
        "${pkgs.taskchampion-sync-server}/bin/taskchampion-sync-server --port 8443";
    };
    wantedBy = [ "multi-user.target" ];
  };

  nixpkgs.config.permittedInsecurePackages = [ "dcraw-9.28.0" ];

}
