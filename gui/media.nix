{ pkgs, ... }: {
  imports = [ ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
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
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.shellAliases.ytt = "proxychains4 -q yt";

}
