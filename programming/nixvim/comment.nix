{ ... }: {

  plugins.comment-nvim.enable = true;
  plugins.comment-nvim.toggler.line = "<leader>/";
  keymaps = [
    {
      key = "<leader>/";
      action =
        "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>";
      options.desc = "Comment visual text";
      mode = "v";
    }
    {
      key = "<leader>/";
      action = ''
        function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end'';
      options.desc = "Comment line";
      lua = true;
      mode = "n";
    }

  ];
}
