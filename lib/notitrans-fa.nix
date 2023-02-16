{pkgs , ... }:
with pkgs ;
writeShellApplication {
  name ="notitrans-fa";
  runtimeInputs = [
    translate-shell
    xsel
    libnotify
  ];
  text = '' 
    text=$(xsel -o)
    brief=$(trans :fa -no-bidi -no-ansi "$text")
    notify-send "$text" "$brief"
    '';
}