{ pkgs, ... }: {
  plugins.toggleterm.enable = true;
  keymaps = [
    {
      key = "<leader>tf";
      action = "<Cmd>ToggleTerm direction=float<CR>";
      mode = "n";
    }
    {
      key = "<leader>th";
      action = "<Cmd>ToggleTerm size=10 direction=horizontal<CR>";
      mode = "n";
    }

    {
      key = "<leader>tv";
      action = "<Cmd>ToggleTerm size=80 direction=vertical<CR>";
      mode = "n";
    }

    {
      key = "<F7>";
      action = "<Cmd>ToggleTerm<CR>";
      mode = "n";
    }

    {
      key = "<F7>";
      action = "<Cmd>ToggleTerm<CR>";
      mode = "t";
    }

    {
      key = "<C-'>";
      action = "<Cmd>ToggleTerm<CR>";
      mode = "n";
    }

    {
      key = "<C-'>";
      action = "<Cmd>ToggleTerm<CR>";
      mode = "t";
    }

  ];
}
