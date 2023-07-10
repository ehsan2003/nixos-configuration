{ pkgs, ... }:
with pkgs;
writeShellApplication {
  name = "restore-backup";
  runtimeInputs = [ ];
  text = ''
    BACKUP_FILE=$1
    tar xzf "$BACKUP_FILE" -P
  '';
}
