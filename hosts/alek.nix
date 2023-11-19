{ pkgs, ... }: {
  imports = [ ./base.nix ];
  networking.hostName = "alek"; # Define your hostname.
  services.xserver.displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --rate 60 &";
  services.tlp.enable = true;
  environment.systemPackages=[
    pkgs.jetbrains.idea-ultimate
    pkgs.brave
  ];

}
