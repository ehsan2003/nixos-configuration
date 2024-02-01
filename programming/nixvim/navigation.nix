{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [ smart-splits-nvim ];
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
      key = "<leader>c";
      action = "<Cmd>bdelete<Cr>";
      options.desc = "exit buffer";
    }
    {
      key = "H";
      action = "<Cmd>bprevious<Cr>";
      mode = "n";
    }
    {
      key = "L";
      action = "<Cmd>bnext<Cr>";
      mode = "n";
    }
    {
      key = "<C-h>";
      action = "function () require('smart-splits').move_cursor_left() end";
      mode = "n";
      lua = true;
    }
    {
      key = "<C-j>";
      action = "function () require('smart-splits').move_cursor_down() end";
      mode = "n";
      lua = true;
    }
    {
      key = "<C-k>";
      action = "function () require('smart-splits').move_cursor_up() end";
      mode = "n";
      lua = true;
    }
    {
      key = "<C-l>";
      action = "function () require('smart-splits').move_cursor_right() end";
      mode = "n";
      lua = true;
    }
    {
      key = "<C-Up>";
      action = "function () require('smart-splits').resize_up() end";
      mode = "n";
      lua = true;
    }
    {
      key = "<C-Down>";
      action = "function () require('smart-splits').resize_down() end";
      mode = "n";
      lua = true;
    }
    {
      key = "<C-Left>";
      action = "function () require('smart-splits').resize_left() end";
      mode = "n";
      lua = true;
    }
    {
      key = "<C-Right>";
      action = "function () require('smart-splits').resize_right() end";
      mode = "n";
      lua = true;
    }
  ];
}
