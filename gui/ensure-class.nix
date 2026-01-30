{ writeShellApplication, sway, jq, gnugrep }:
writeShellApplication {
  name = "ensure-class";
  runtimeInputs = [ sway jq gnugrep ];
  text = ''
    swaymsg -t get_tree | jq -r '.. | select(.window_properties?.class?) | .window_properties.instance' | grep -q "^$1$" || swaymsg exec "$2" 
  '';
}
