{ pkgs, ... }: {
  imports = [ ];
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraConfig = "load-module module-combine-sink";
    package = pkgs.pulseaudioFull;
  };
  environment.systemPackages = with pkgs; [
    (import ./lib/music-crawler.nix { inherit pkgs; })
    (import ./lib/music-play.nix { inherit pkgs; })
    obs-studio
    ffmpeg-full
    vlc
    smplayer
    mplayer
    gupnp
    yewtube
    subdl
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;


  environment.shellAliases.ytt = "proxychains4 -q yt";

systemd.services.gupnpd = {
    description = "GUPnP daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.gupnp}/bin/gupnpd";
      Restart = "on-failure";
    };
  };
}
