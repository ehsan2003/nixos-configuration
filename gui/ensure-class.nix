{ writeShellApplication, i3, jq, gnugrep }:
writeShellApplication {
  name = "ensure-class";
  runtimeInputs = [ i3 jq gnugrep ];
  text = ''
    i3-msg -t get_tree | jq -r '.. | select(.window_properties?.class?) | .window_properties.instance' | grep -q "^$1$" || i3-msg exec "$2" 
  '';
}
