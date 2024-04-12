{ writeShellApplication, gnugrep, iproute2, jq, coreutils }:
writeShellApplication {
  name = "internet-gateway";
  runtimeInputs = [ gnugrep iproute2 jq coreutils ];
  text = ''
    device=$(ip --json route show | jq '.[] |.dev' --raw-output | grep -vFf <(ls /sys/devices/virtual/net/) | head -n 1)
    ip -j route show default dev "$device" | jq '.[0].gateway' --raw-output
  '';
}
