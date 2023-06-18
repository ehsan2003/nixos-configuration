{ pkgs, ... }:
with pkgs;
writeShellApplication rec {
  name = "restore-backup";
  runtimeInputs = [ ];
  text = ''
    BACKUP_FILE=$1
    tar xzf "$BACKUP_FILE" -P
  '';
}
