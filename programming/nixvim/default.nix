{ pkgs, fenix, ... }: {
  imports = [
    ./lsp.nix
    ./telescope.nix
    ./terminal.nix
    ./options.nix
    ./navigation.nix
    ./gitsigns.nix
    ./ui.nix
    ./comment.nix
    ./treesitter.nix
    ./agentic.nix
  ];
  config = {
    plugins.yanky.enable = true;
    plugins.yanky.settings.highlight.timer = 100;
    plugins.auto-save.enable = true;
    plugins.git-conflict.enable = true;
    plugins.oil.enable = true;
    plugins.visual-multi.enable = true;
    plugins.auto-session.enable = true;
    plugins.auto-session.settings.bypass_save_filetypes = [ "neo-tree" ];
    extraConfigVim = ''
      let g:auto_session_pre_save_cmds = ["Neotree close"]
    '';
  };

}
