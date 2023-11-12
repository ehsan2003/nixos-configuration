pkgs: name: url:
pkgs.writeShellApplication {
  inherit name;
  runtimeInputs = [ pkgs.xdg-utils ];
  text = ''
    xdg-open ${url}
  '';
}
