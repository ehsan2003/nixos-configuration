{ astroNvim, pkgs, ... }:
{
  environment.systemPackages = with pkgs;[
    neovim
    neovide
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions;
        [
          bbenoist.nix
          ms-python.python
          ms-azuretools.vscode-docker
          ms-vscode-remote.remote-ssh
          vscodevim.vim
          rust-lang.rust-analyzer
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }];
    })
    rust-analyzer
    nixfmt
    pyright
    nil
    nodePackages.typescript-language-server
    nodePackages.typescript
    nodePackages.prettier
    llvmPackages_15.clang-unwrapped
    lua-language-server
    stylua

  ];
  home-manager.users.ehsan = {
    home.file.astroNvim = {
      source = astroNvim.outPath;
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

  environment.shellAliases.v = "neovide";
}
