{ pkgs, nix-alien, unstable, secrets, ... }:
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
  environment.variables.OPENAI_API_HOST = secrets.OPENAI_API_HOST;

  home-manager.users.ehsan.programs.taskwarrior.enable = true;
  home-manager.users.ehsan.programs.taskwarrior.package = unstable.taskwarrior3;
  home-manager.users.ehsan.programs.taskwarrior.config = {
    sync.encryption_secret = secrets.taskwarrior-secret;
    sync.server.client_id = "aa529e36-0e93-4d5a-90e4-921f942aa0d7";
    sync.server.origin = "http://localhost:8443";
  };

  home-manager.users.ehsan.home.file.timewarrior-hook = {
    executable = true;
    source = "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
    target = ".local/share/task/hooks/on-modify.timewarrior";
  };

  environment.systemPackages = (with pkgs; [
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
    zip
    tree
    ncdu
    imagemagick
    chntpw
    zellij
    timewarrior
    llama-cpp
  ]) ++ [
    nix-alien.packages.${"x86_64-linux"}.nix-alien
    (urls "mathcha" "https://mathcha.io/editor")
    (urls "poe" "https://poe.com")
    (urls "meet" "https://meet.google.com/")
    (urls "claude" "https://claude.ai/")

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
