{ pkgs, ... }: {
  config = {
    colorschemes.tokyonight.enable = true;
    globals.mapleader = " ";
    clipboard.providers.xclip.enable = true;
    clipboard.register = "unnamedplus";
    opts.shiftwidth = 2; # Tab width should be 2
    opts.expandtab = true; # Tab width should be 2
    opts.tabstop = 2; # Tab width should be 2
    opts.softtabstop = 2; # Tab width should be 2
    opts.number = true; # Tab width should be 2
    opts.cmdheight = 0;
    opts.signcolumn = "yes:1";
    opts.cursorline = true;
    opts.undofile = true;
    opts.wrap = false;
    opts.guifont = "FiraCode Nerd Font:h12";
    opts.hlsearch = false;

  };
}
