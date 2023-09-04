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
  nixpkgs.overlays = [
    (import "${fetchTarball "https://github.com/nix-community/fenix/archive/main.tar.gz"}/overlay.nix")
  ];
   
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
    unstable.deno
    nixfmt
    docker-compose
    cloc
    nix-output-monitor

    insomnia
    cargo-watch
    rust-analyzer
    (fenix.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
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
  virtualisation.docker.package = unstable.docker_24;
  environment.shellAliases.v = "nvim";
  programs.git.config = { init = { defaultBranch = "main"; }; };
}
