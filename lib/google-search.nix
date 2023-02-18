{pkgs , ... }:
with pkgs ;
writeShellApplication {
  name ="google-search";
  runtimeInputs = [
    firefox
    xsel
  ];
  text = '' 
         text=$(xsel -o)
         firefox --new-tab "https://www.google.com/search?q=$text"  
      '';
}