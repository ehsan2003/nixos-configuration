{ pkgs, nix-alien, secrets, ... }:
let urls = (import ./uri-short.nix pkgs);
in {
  imports = [ ];

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  # $ nix search wget
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  services.atd.enable = true;
  environment.variables.OPENAI_API_KEY = secrets.OPENAI_API_KEY;

  home-manager.users.ehsan.programs.taskwarrior.enable = true;
  home-manager.users.ehsan.home.file.timewarrior-hook = {
    executable = true;
    source = "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
    target = ".local/share/task/hooks/on-modify.timewarrior";
  };

  environment.systemPackages = with pkgs; [
    # editors
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    openssl

    # Netowrk
    wget
    curl
    aria2

    # Absolute Utils
    killall
    btop
    unrar-wrapper
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
    xclip
    nix-alien.packages.${"x86_64-linux"}.nix-alien
    (urls "mathcha" "https://mathcha.io/editor")
    (urls "poe" "https://poe.com")
    (urls "meet" "https://meet.google.com/")
    (urls "claude" "https://claude.ai/")

    toybox
    zip
    tree
    ncdu
    imagemagick
    chntpw
    zellij
    timewarrior
  ];
  home-manager.users.ehsan.home.file.zshrc = {
    text = ''
      task
    '';
    target = ".zshrc";
  };
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" "vi-mode" "docker" "docker-compose" ];
    theme = "robbyrussell";
  };
}
