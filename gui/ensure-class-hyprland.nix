{
  writeShellApplication,
  hyprland,
  jq,
  gnugrep,
}:
writeShellApplication {
  name = "ensure-class-hyprland";
  runtimeInputs = [
    hyprland
    jq
    gnugrep
  ];
  text = ''
    # Check if a window with the specified class is already running
    # Uses Hyprland's IPC instead of Sway's
    hyprctl clients -j | jq -r '.[] | .class' | grep -q "^$1$" || hyprctl dispatch exec "$2"
  '';
}
