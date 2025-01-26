{ writeShellApplication, rofi, aichat, i3, alacritty, xorg }:
writeShellApplication {
  name = "aiask";
  runtimeInputs = [ rofi aichat i3 alacritty xorg.xrandr ];
  text = ''
    prompt=$(rofi -dmenu -p "🤖")
    read -r screen_width screen_height < <(xrandr | grep '\*' | awk '{print $1}' | tr 'x' ' ')
    window_width=$((screen_width / 2))
    window_height=$(((screen_height / 3) * 2))
    alacritty -t "AI Chat" --option colors.primary.background=\'#111111\' -e sh -c \
      "i3-msg -q 'floating enable, move position $((screen_width - window_width)) px 0, resize set $window_width px $window_height' && aichat --prompt 'You are a short responder assistant' -m openrouter:deepseek/deepseek-r1-distill-llama-70b '$prompt' ; read"
  '';
}
