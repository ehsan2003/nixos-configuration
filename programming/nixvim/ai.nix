{ pkgs, ... }:
let
  vim-ai = pkgs.vimUtils.buildVimPlugin {
    name = "vim-ai";
    src = pkgs.fetchFromGitHub {
      owner = "madox2";
      repo = "vim-ai";
      rev = "819c1bb3c79080128a076aff03b16cfc1f4548c7";
      sha256 = "sha256-BZCrQkJzGKZQTvRR/ib6W9vFOSQXlo2nzEQ52jOmJDc=";
    };
  };
in {
  extraPlugins = [ vim-ai ];
  keymaps = [
    {
      key = "<leader>ai";
      action.__raw = ''
        function ()
          vim.ui.input({ prompt = "gpt Prompt" }, function(query)
            if query then
              vim.cmd('AI '..query)
            end
          end)
        end
      '';

      mode = "n";
    }
    {
      key = "<leader>ai";
      action.__raw = ''
        function ()
          vim.ui.input({ prompt = "gpt Prompt" }, function(query)
            if query then
              vim.cmd("'<,'>AI "..query)
            end
          end)
        end
      '';

      mode = "v";
    }
    {
      key = "<leader>ae";
      action.__raw = ''
        function ()
          vim.ui.input({ prompt = "edit prompt" }, function(query)
            if query then
              vim.cmd('AIEdit '..query)
            end
          end)
        end
      '';

      mode = "n";
    }
    {
      key = "<leader>ae";
      action.__raw = ''
        function ()
          vim.ui.input({ prompt = "edit prompt" }, function(query)
            if query then
              vim.cmd("'<,'>AIEdit "..query)
            end
          end)
        end
      '';

      mode = "v";
    }
    {
      key = "<leader>ac";
      action.__raw = ''
        function ()
          vim.ui.input({ prompt = "chat prompt" }, function(query)
            if query then
              vim.cmd('AIChat '..query)
            end
          end)
        end
      '';

      mode = "n";
    }
    {
      key = "<leader>ac";
      action.__raw = ''
        function ()
          vim.ui.input({ prompt = "chat prompt" }, function(query)
            if query then
              vim.cmd("'<,'>AIChat "..query)
            end
          end)
        end
      '';

      mode = "v";
    }
    {
      key = "<leader>ar";
      action = "<cmd>'<,'>AIRedo<cr>";
      mode = "v";
    }
    {
      key = "<leader>ar";
      action = "<cmd>AIRedo<cr>";
      mode = "n";
    }
  ];

}
