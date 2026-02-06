{
  writeShellApplication,
  wofi,
  aichat,
  sway,
  alacritty,
  jq,
}:
writeShellApplication {
  name = "aiask";
  runtimeInputs = [
    wofi
    aichat
    sway
    alacritty
    jq
  ];
  text = ''
    prompt=$(wofi -dmenu -p "🤖")
    read -r screen_width screen_height < <(swaymsg -t get_outputs | jq -r '.[0].current_mode.width, .[0].current_mode.height')
    window_width=$((screen_width / 2))
    window_height=$(((screen_height / 3) * 2))
    alacritty -t "AI Chat" --option colors.primary.background=\'#111111\' -e sh -c \
      "swaymsg 'floating enable, move position $((screen_width - window_width)) px 0, resize set $window_width px $window_height' && aichat --prompt 'You are a short responder assistant' -m openrouter:deepseek/deepseek-r1-distill-llama-70b '$prompt' ; read"
  '';
}
