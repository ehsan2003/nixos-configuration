{ pkgs, ... }: {
  plugins.bufferline.enable = true;
  extraPlugins = with pkgs.vimPlugins; [ dressing-nvim ];
  plugins.which-key.enable = true;
  plugins.which-key.registrations = {
    "<leader>f" = "Find";
    "<leader>t" = "Terminal";
    "<leader>l" = "Lsp";
    "<leader>g" = "Git";
  };
  plugins.lualine.enable = true;
  plugins.neo-tree.enable = true;
  plugins.neo-tree.filesystem.filteredItems.visible = true;

  plugins.noice.enable = true;
  plugins.noice.presets = {
    bottom_search = true;
    command_palette = true;
    long_message_to_split = true;
    inc_rename = false;
    lsp_doc_border = false;
  };
  plugins.noice.popupmenu.enabled = false;

}
