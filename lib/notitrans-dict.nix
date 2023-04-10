

{ pkgs, ... }:
with pkgs;
writeShellApplication {
  name = "notitrans-dict";
  runtimeInputs = [ translate-shell xsel libnotify ];
  text = ''
    text=$(xsel -o)
    complete=$(trans -d  -no-ansi "$text")
    brief=$(trans :fa -no-bidi -no-ansi -b "$text")

    notify-send "$text" "$(printf "%s\n%s" "$brief" "$complete")"
  '';
}
