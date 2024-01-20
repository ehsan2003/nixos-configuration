{ astroNvim, pkgs, ... }:
{
  environment.systemPackages = with pkgs;[
    neovim
    neovide
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
