{ writeShellApplication, translate-shell, wl-clipboard, libnotify }:
writeShellApplication {
  name = "notitrans-dict";
  runtimeInputs = [ translate-shell wl-clipboard libnotify ];
  text = ''
    text=$(wl-paste)
    complete=$(trans -d  -no-ansi "$text")
    brief=$(trans :fa -no-bidi -no-ansi -b "$text")

    notify-send "$text" "$(printf "%s\n%s" "$brief" "$complete")"
  '';
}
