{ writeShellApplication, firefox, wl-clipboard }:
writeShellApplication {
  name = "search-select";
  runtimeInputs = [ firefox wl-clipboard ];
  text = ''
    text=$(wl-paste)
    firefox --search "$text"  
  '';
}
