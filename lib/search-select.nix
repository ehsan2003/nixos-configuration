{ pkgs, ... }:
with pkgs;
writeShellApplication {
  name = "search-select";
  runtimeInputs = [ firefox xsel ];
  text = ''
    text=$(xsel -o)
    firefox --search "$text"  
  '';
}
