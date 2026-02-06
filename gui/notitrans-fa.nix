{
  writeShellApplication,
  translate-shell,
  wl-clipboard,
  libnotify,
}:
writeShellApplication {
  name = "notitrans-fa";
  runtimeInputs = [
    translate-shell
    wl-clipboard
    libnotify
  ];
  text = ''
    text=$(wl-paste --primary )
    brief=$(trans :fa -no-bidi -no-ansi "$text")
    notify-send "$text" "$brief"
  '';
}
