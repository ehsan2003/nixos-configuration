{ writeShellApplication, rofi, aichat, i3, alacritty }:
writeShellApplication {
  name = "aiask";
  runtimeInputs = [ rofi aichat i3 alacritty ];
  text = ''
    prompt=$(rofi -dmenu -p "🤖")
    read screen_width _ < <(xrandr | grep '*' | awk '{print $1}' | tr 'x' ' ')
    window_width=$((screen_width / 3))
    alacritty -t "AI Chat" --option window.dimensions.columns=80 --option window.dimensions.lines=25 \
      --option window.position.x=$((screen_width - window_width)) --hold -e sh -c \
      "i3-msg 'floating enable, move position 0 px 0, resize set $window_width px 700' && aichat '$prompt'"
  '';
}
