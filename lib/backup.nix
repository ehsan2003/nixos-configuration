{ pkgs, ... }:
with pkgs;
let backupFiles = import ./vpn-backup-files.nix;
in writeShellApplication rec {
  name = "backup";
  runtimeInputs = [ ];
  text = ''
    BACKUP_FILE=backup-$(date -I).tar
    tar czf  "$BACKUP_FILE" -P ${pkgs.lib.concatStringsSep " " backupFiles}
  '';
}
