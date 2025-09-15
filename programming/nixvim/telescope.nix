{ pkgs, ... }: {
  plugins.project-nvim.enable = true;
  plugins.project-nvim.enableTelescope = true;
  plugins.project-nvim.settings = {
    # Manual mode doesn't automatically change your root directory, so you have
    # the option to manually do so using `:ProjectRoot` command.
    manual_mode = false;

    # Methods of detecting the root directory. **"lsp"** uses the native neovim
    # lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
    # order matters: if one is not detected, the other is used as fallback. You
    # can also delete or rearangne the detection methods.
    detection_methods = [ "pattern" ];

    # All the patterns used to detect root dir, when **"pattern"** is in
    # detection_methods
    patterns = [ ".git" ];

    # Table of lsp clients to ignore by name
    # eg: { "efm", ... }

    # Don't calculate root dir on specific directories
    # Ex: { "~/.cargo/*", ... }

    # Show hidden files in telescope
    show_hidden = false;

    # When set to false, you will get a message when project.nvim changes your
    # directory.
    silent_chdir = true;

    # What scope to change the directory, valid options are
    # * global (default)
    # * tab
    # * win
    scope_chdir = "global";

  };

  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>fr" = { action = "registers"; };
      "<leader>fw" = { action = "live_grep hidden=true"; };
      "<leader>ff" = { action = "find_files hidden=true"; };
      "<leader>f<CR>" = { action = "resume"; };
      "<leader>fp" = { action = "projects"; };
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
