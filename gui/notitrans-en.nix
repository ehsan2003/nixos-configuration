{ writeShellApplication, translate-shell, xsel, libnotify }:
writeShellApplication {
  name = "notitrans-en";
  runtimeInputs = [ translate-shell xsel libnotify ];
  text = ''
    text=$(xsel -o)
    brief=$(trans :en -no-ansi "$text")
    notify-send "$text" "$brief"
  '';
}
