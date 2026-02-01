{ writeShellApplication, translate-shell, wl-clipboard, libnotify }:
writeShellApplication {
  name = "notitrans-en";
  runtimeInputs = [ translate-shell wl-clipboard libnotify ];
  text = ''
    text=$(wl-paste --primary)
    brief=$(trans :en -no-ansi "$text")
    notify-send "$text" "$brief"
  '';
}
