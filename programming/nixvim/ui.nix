{ pkgs, ... }: {
  plugins.dressing.enable = true;
  plugins.which-key.enable = true;
  plugins.web-devicons.enable = true;
  plugins.which-key.settings.spec = let
    transformSet = set:
      builtins.map (name: {
        __unkeyed-1 = name;
        desc = set.${name};
      }) (builtins.attrNames set);

  in transformSet {
    "<leader>a" = "AI";
    "<leader>f" = "Find";
    "<leader>t" = "Terminal";
    "<leader>l" = "Lsp";
    "<leader>g" = "Git";
  };
  plugins.lualine.enable = true;
  plugins.neo-tree.enable = true;
  plugins.neo-tree.filesystem.filteredItems.visible = true;

  plugins.noice.enable = true;
  plugins.noice.settings.presets = {
    bottom_search = true;
    command_palette = true;
    long_message_to_split = true;
    inc_rename = false;
    lsp_doc_border = false;
  };
  plugins.noice.settings.popupmenu.enabled = false;

}
