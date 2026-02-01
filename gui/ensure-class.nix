{
  writeShellApplication,
  sway,
  jq,
  gnugrep,
}:
writeShellApplication {
  name = "ensure-class";
  runtimeInputs = [
    sway
    jq
    gnugrep
  ];
  text = ''
    # Check both app_id (Wayland) and window_properties.instance (X11)
    swaymsg -t get_tree | jq -r '.. | select(.app_id? or .window_properties?.instance?) | .app_id // .window_properties.instance // empty' | grep -q "^$1$" || swaymsg exec "$2"
  '';
}
