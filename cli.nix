# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let urls = (import ./lib/uri-short.nix pkgs);
nix-alien-pkgs = import (
    builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) { };

in {
  imports = [ ];

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  # $ nix search wget
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  environment.systemPackages = with pkgs; [
    # editors
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    # Netowrk
    wget
    curl
    aria2

    # Absolute Utils
    killall
    htop
    unzip
    ripgrep
    fd
    bat
    jcal
    jq
    ddgr
    pup
    tmux
    v4l-utils
    github-cli
    chatgpt-cli
    nix-alien-pkgs.nix-alien
    (urls "mathcha" "https://mathcha.io/editor")
    (urls "poe" "https://poe.com")
    (urls "meet" "https://meet.google.com/")
    (urls "claude" "https://claude.ai/")
    (rustPlatform.buildRustPackage {
      pname = "praytimes-kit";
      version = "1.0.0";

      src = fetchFromGitHub {
        owner = "basemax";
        repo = "praytimesrust";
        rev = "2c3eb40c4d4bf7a3c3bf484e1a5400a8c4b9a381";
        sha256 = "sha256-qOKPXKERkWBePusM/YG9OoTmWHznSJUltYTWKTUJ9q8=" ;
      };

   cargoSha256 = pkgs.lib.fakeHash ;

      meta = with pkgs.lib; {
        description = "A rust based praytimes calculator";
        homepage = "https://github.com/basemax/praytimesrust";
        license = licenses.gpl3;
      };
    })
  ];
 programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" "vi-mode" "docker" "docker-compose" ];
    theme = "robbyrussell";
  };
}
