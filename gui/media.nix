{ pkgs, ... }: {
  imports = [ ];
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraConfig = "load-module module-combine-sink";
    package = pkgs.pulseaudioFull;
  };
  environment.systemPackages = with pkgs; [
    mkvtoolnix
    vokoscreen
    ffmpeg-full
    vlc
    smplayer
    mplayer
    yewtube
    subdl
    popcorntime
    nodePackages.webtorrent-cli
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.shellAliases.ytt = "proxychains4 -q yt";

}
