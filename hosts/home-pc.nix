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

  nixpkgs.config.permittedInsecurePackages = [ "dcraw-9.28.0" ];
  boot.kernelParams = [
    "cgroup_enable=memory"
    "swapaccount=1"
    "systemd.unified_cgroup_hierarchy=0" # Only if needed
  ];

}
