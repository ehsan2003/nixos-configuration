{ writeShellApplication, libnotify, rofi, aichat }:
writeShellApplication {
  name = "aiask";
  runtimeInputs = [ libnotify rofi aichat ];
  text = ''
    prompt=$(rofi -dmenu -p "Enter your text")
    notify_id=$(notify-send -p -c "$prompt" "Waiting...")
    aichat "$prompt" | while read -r chunk; do
      notify-send -r "$notify_id" -c "$prompt" "$chunk"
    done
  '';
}
