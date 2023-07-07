{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "music-link";
  runtimeInputs = with pkgs; [ ddgr jq pup curl ];
  text = ''
    url=$(ddgr "$@" --json | jq '.[0].url' -r)
    curl "$url" | pup 'audio > source attr{src}'
  '';
}
