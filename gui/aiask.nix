{ writeShellApplication, libnotify, rofi, aichat }:
writeShellApplication {
  name = "aiask";
  runtimeInputs = [ libnotify rofi aichat ];
  text = ''
    prompt=$(rofi -dmenu -p "Enter your text")
    notify_id=$(notify-send -p "$prompt" "Waiting...")
    full_response=""
    aichat "$prompt" | while read -r chunk; do
      full_response="$full_response$chunk"
      notify-send -r "$notify_id" "$prompt" "$full_response"
    done
  '';
}
