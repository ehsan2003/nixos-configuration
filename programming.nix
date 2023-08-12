{ pkgs, ... }:
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
        extraConfig = { init = { defaultBranch = "main"; }; };
      };
    };
  };
  environment.systemPackages = with pkgs; [
    neovim
    (vscode-with-extensions.override {
        vscode = vscodium;
        vscodeExtensions = with vscode-extensions; [
          bbenoist.nix
          ms-python.python
          ms-azuretools.vscode-docker
          ms-vscode-remote.remote-ssh
          vscodevim.vim
          rust-lang.rust-analyzer
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.47.2";
            sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
          }
        ];
      })


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
    pre-commit
  ];
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "ehsan" ];
  virtualisation.docker.enable = true;
  virtualisation.docker.package = let
    pkgs = import (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify                
      name = "with-docker-20.10.23";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8";
    }) { };
  in pkgs.docker;
  environment.shellAliases.v = "nvim";
  programs.git.config = { init = { defaultBranch = "main"; }; };
}
