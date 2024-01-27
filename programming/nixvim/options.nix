{ pkgs, ... }: {
  config = {
    colorschemes.tokyonight.enable = true;
    globals.mapleader = " ";
    clipboard.providers.xclip.enable = true;
    clipboard.register = "unnamedplus";
    options.shiftwidth = 2; # Tab width should be 2
    options.expandtab = true; # Tab width should be 2
    options.tabstop = 2; # Tab width should be 2
    options.softtabstop = 2; # Tab width should be 2
    options.number = true; # Tab width should be 2
    options.cmdheight = 0;
    options.signcolumn = "yes:1";
    options.cursorline = true;
    options.undofile = true;
    options.wrap = false;
    options.guifont = "FiraCode Nerd Font:h12";
    options.hlsearch = false;

  };
}
