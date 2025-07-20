{ pkgs, ... }: {
  imports = [ ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  environment.systemPackages = with pkgs; [
    mkvtoolnix
    ffmpeg
    vlc
    popcorntime
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
