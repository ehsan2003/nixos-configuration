
{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "music-play";
  runtimeInputs = with pkgs; [ mplayer (import ./music-crawler.nix {inherit pkgs;})];
  text = ''
    mplayer "$(music-link "$@" | head -1)"
  '';
}
