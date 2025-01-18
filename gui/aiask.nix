{ writeShellApplication, libnotify, rofi, aichat }:
writeShellApplication {
  name = "aiask";
  runtimeInputs = [ libnotify rofi aichat ];
  text = ''
    notify-send c "$( rofi -dmenu -p "Enter your text"| aichat)"
  '';
}
