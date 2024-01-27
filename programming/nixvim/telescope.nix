{ pkgs, ... }: {
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>fr" = {
        desc = "registers";
        action = "registers";

      };
      "<leader>fw" = {
        desc = "search";
        action = "live_grep";
      };
      "<leader>ff" = {
        desc = "file finder";
        action = "find_files";
      };
    };

    defaults.sorting_strategy = "ascending";
    defaults.layout_config = {
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
