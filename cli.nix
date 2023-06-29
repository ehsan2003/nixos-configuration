# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [ ];

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  # $ nix search wget
  environment.variables ={
    EDITOR="nvim";
    VISUAL="nvim";
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
    (import ./lib/ask.nix {inherit pkgs;})

  ];
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" "vi-mode" ];
    theme = "robbyrussell";
  };
}
