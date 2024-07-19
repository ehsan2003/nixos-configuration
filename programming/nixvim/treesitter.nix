{ ... }: {
  plugins.hmts.enable = true;
  plugins.treesitter = {
    enable = true;
    settings.incremental_selection = {
      enable = true;
      keymaps.init_selection = "<A-h>";
      keymaps.node_decremental = "<A-l>";
      keymaps.node_incremental = "<A-h>";
    };
  };
}
