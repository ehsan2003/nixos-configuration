{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { };
in {
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
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
