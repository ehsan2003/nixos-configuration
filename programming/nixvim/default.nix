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
    ./ai.nix
  ];
  config = {
    plugins.yanky.enable = true;
    plugins.yanky.highlight.timer = 100;
    plugins.auto-save.enable = true;
    plugins.auto-session.enable = true;
    plugins.auto-session.bypassSessionSaveFileTypes = [ "neo-tree" ];
    extraConfigVim = ''
      let g:auto_session_pre_save_cmds = ["Neotree close"]
    '';
  };

}
