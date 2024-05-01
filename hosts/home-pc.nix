{ pkgs, unstable, ... }:
let dpi = 250;
in {
  imports = [ ./base.nix ];
  networking.hostName = "nixos-home-desktop"; # Define your hostname.

  home-manager.users.ehsan.home.pointerCursor = {
    x11.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 128;
  };

  services.xserver.dpi = dpi;
  home-manager.users.ehsan.programs.rofi.extraConfig."dpi" = dpi;
  console.font = pkgs.lib.mkForce "Lat2-Terminus32";
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: ${toString dpi}  
    EOF
  '';
  services.serviio.enable = true;
  systemd.services.task-sync = {
    enable = true;
    description = "taskwarrior sync server";
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart =
        "${unstable.taskchampion-sync-server}/bin/taskchampion-sync-server --port 8443";
    };
    wantedBy = [ "multi-user.target" ];
  };

  home-manager.users.ehsan.programs.taskwarrior.config = {
    sync.server.origin = "http://localhost:8443";
    sync.server.client_id = "aa529e36-0e93-4d5a-90e4-921f942aa0d7";
  };
  nixpkgs.config.permittedInsecurePackages = [ "dcraw-9.28.0" ];

}
