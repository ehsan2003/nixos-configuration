{ pkgs, ... }: {
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>fr" = { action = "registers"; };
      "<leader>fw" = { action = "live_grep"; };
      "<leader>ff" = { action = "find_files"; };
      "<leader>f<CR>" = { action = "resume"; };
    };

    settings.defaults.sorting_strategy = "ascending";
    settings.defaults.layout_config = {
      horizontal = {
        prompt_position = "top";
        preview_width = 0.55;
      };
      vertical = { mirror = false; };
      width = 0.87;
      height = 0.8;
      preview_cutoff = 120;
    };
  };
}
