{ writeShellApplication, firefox, xsel }:
writeShellApplication {
  name = "search-select";
  runtimeInputs = [ firefox xsel ];
  text = ''
    text=$(xsel -o)
    firefox --search "$text"  
  '';
}
