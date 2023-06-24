{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { };
in {
  imports = [ ];
  home-manager.users.ehsan = {
    home.file.astroNvim = {
      source =
        (fetchGit { url = "https://github.com/AstroNvim/AstroNvim"; }).outPath;
      target = ".config/nvim";
    };
    home.file.astroNvimConfig = {
      text = builtins.readFile ./astronvim.init.lua;
      target = ".config/astronvim/lua/user/init.lua";
    };

    programs = {
      git = {
        enable = true;
        userName = "ehsan";
        userEmail = "ehsan2003.2003.382@gmail.com";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    neovim
    nodejs
    yarn
    python39
    git
    gcc
    unstable.cargo
    unstable.rustc
    unstable.deno
    nixfmt
    unstable.rustfmt
    docker-compose
    cloc
    nix-output-monitor

    unstable.rust-analyzer
    pyright
    nil
    nodePackages.typescript-language-server
    nodePackages.typescript
    nodePackages.prettier
    llvmPackages_15.clang-unwrapped
    lua-language-server
    stylua
  ];
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "ehsan" ];
  virtualisation.docker.enable = true;
  programs.zsh.shellAliases.v = "nvim";
  programs.git.config = {
    init = { defaultBranch = "main"; };
    url = { "https://github.com/" = { insteadOf = [ "gh:" "github:" ]; }; };
  };
}
