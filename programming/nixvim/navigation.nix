{ ... }:
{

  plugins.smart-splits.enable = true;
  plugins.cybu.enable = true;
  plugins.cybu.settings = {
    position = {
      relative_to = "win"; # win, editor, cursor
      anchor = "topcenter"; # topleft, topcenter, topright,
      # centerleft, center, centerright,
      # bottomleft, bottomcenter, bottomright
      vertical_offset = 10; # vertical offset from anchor in lines
      horizontal_offset = 0; # vertical offset from anchor in columns
      max_win_height = 5; # height of cybu window in lines
      max_win_width = 0.5; # integer for absolute in columns
      # float for relative to win/editor width
    };
    style = {
      path = "relative"; # absolute, relative, tail (filename only),
      # tail_dir (filename & parent dir)
      path_abbreviation = "none"; # none, shortened
      border = "rounded"; # single, double, rounded, none
      separator = " "; # string used as separator
      prefix = "…"; # string used as prefix for truncated paths
      padding = 1; # left & right padding in number of spaces
      hide_buffer_id = true; # hide buffer IDs in window
      devicons = {
        enabled = true; # enable or disable web dev icons
        colored = true; # enable color for web dev icons
        truncate = true; # truncate wide icons to one char width
      };
      highlights = {
        # see highlights via :highlight
        current_buffer = "CybuFocus"; # current / selected buffer
        adjacent_buffers = "CybuAdjacent"; # buffers not in focus
        background = "CybuBackground"; # window background
        border = "CybuBorder"; # border of the window
      };
    };
    behavior = {
      # set behavior for different modes
      mode = {
        default = {
          switch = "on_close"; # immediate, on_close
          view = "rolling"; # paging, rolling
        };
        last_used = {
          switch = "on_close"; # immediate, on_close
          view = "rolling"; # paging, rolling
          update_on = "buf_enter"; # buf_enter, cursor_moved
        };
        auto = {
          view = "rolling"; # paging, rolling
        };
      };
      show_on_autocmd = false; # event to trigger cybu (eg. "BufEnter")
    };
    display_time = 700; # time the cybu window is displayed
    exclude = [
      # filetypes, cybu will not be active
      "neo-tree"
      "fugitive"
      "qf"
    ];
    filter = {
      unlisted = true; # filter & fallback for unlisted buffers
    };
  };
  keymaps = [
    {
      # Default mode is "" which means normal-visual-op
      key = "<leader>e";
      action = "<Cmd>Neotree toggle reveal<CR>";
      options.desc = "Explorer";
    }
    {
      key = "<leader>q";
      action = "<Cmd>confirm q<Cr>";
      options.desc = "Quit";
    }
    {
      key = "<leader>C";
      action = "<Cmd>%bd<Cr>";
      options.desc = "exit all buffer";
    }
    {
      key = "<leader>c";
      action = "<Cmd>bdelete<Cr>";
      options.desc = "exit buffer";
    }
    {
      key = "H";
      action = "<Plug>(CybuLastusedPrev)";
      mode = "n";
    }
    {
      key = "L";
      action = "<Plug>(CybuLastusedNext)";
      mode = "n";
    }
    {
      key = "<C-h>";
      action.__raw = "function () require('smart-splits').move_cursor_left() end";
      mode = "n";
    }
    {
      key = "<C-j>";
      action.__raw = "function () require('smart-splits').move_cursor_down() end";
      mode = "n";
    }
    {
      key = "<C-k>";
      action.__raw = "function () require('smart-splits').move_cursor_up() end";
      mode = "n";
    }
    {
      key = "<C-l>";
      action.__raw = "function () require('smart-splits').move_cursor_right() end";
      mode = "n";
    }
    {
      key = "<C-Up>";
      action.__raw = "function () require('smart-splits').resize_up() end";
      mode = "n";
    }
    {
      key = "<C-Down>";
      action.__raw = "function () require('smart-splits').resize_down() end";
      mode = "n";
    }
    {
      key = "<C-Left>";
      action.__raw = "function () require('smart-splits').resize_left() end";
      mode = "n";
    }
    {
      key = "<C-Right>";
      action.__raw = "function () require('smart-splits').resize_right() end";
      mode = "n";
    }
  ];
}
