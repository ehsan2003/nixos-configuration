{ ... }: {
  plugins.gitsigns.enable = true;
  keymaps = [
    {
      key = "]g";
      action = "<cmd>Gitsigns prev_hunk<cr>";
      mode = "n";
    }
    {
      key = "[g";
      action = "<cmd>Gitsigns next_hunk<cr>";
      mode = "n";
    }
    {
      key = "<leader>gd";
      action = "<cmd>Gitsigns diffthis<cr>";
      mode = "n";
    }
  ];
}
