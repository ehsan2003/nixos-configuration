{ ... }:
{

  plugins.smart-splits.enable = true;
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
