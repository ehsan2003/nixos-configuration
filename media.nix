
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
    obs-studio
    ffmpeg
    vlc
    smplayer
    mplayer
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
