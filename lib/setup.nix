{ pkgs, ... }:
with pkgs;
writeShellApplication {
  name = "setup-nixos";
  runtimeInputs = [ gh ];
  text = ''
    echo "github authentication"
    gh auth login

    echo "changing user's password's"
    passwd
    echo "now Its time to restore backups use the restore-backup command with a tar file's name to restore backup";
    echo "or just simply forget about backup stuff and exit the shell";
    sudo PS1="restore > " zsh;
  '';
}
