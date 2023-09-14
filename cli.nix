# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let
  urls = (import ./lib/uri-short.nix pkgs);
  nix-alien-pkgs = import (builtins.fetchTarball
    "https://github.com/thiagokokada/nix-alien/tarball/master") { };

in {
  imports = [ 
    ./praytimes.nix
  ];

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
    nethogs
    nix-alien-pkgs.nix-alien
    (urls "mathcha" "https://mathcha.io/editor")
    (urls "poe" "https://poe.com")
    (urls "meet" "https://meet.google.com/")
    (urls "claude" "https://claude.ai/")

    praytimes-kit
    zip
  ];
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" "vi-mode" "docker" "docker-compose" ];
    theme = "robbyrussell";
  };
}
