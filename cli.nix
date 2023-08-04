# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let urls = (import ./lib/uri-short.nix pkgs);
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
    (urls "mathcha" "https://mathcha.io/editor")
    (urls "poe" "https://poe.com")
    (pkgs.python39Packages.buildPythonPackage rec {
    pname = "hey-gpt";
    version = "1.0.0";
    doCheck = false;
    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "1qnavwpnbwjyl0470zfrpwhswmgxlj2r8z0x3mazx39idivn8w5b";
    };
  })
  ];
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" "vi-mode" "docker" "docker-compose"];
    theme = "robbyrussell";
  };
}
