{ pkgs, ... }:
{
  config = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "agentic-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "carlos-algms";
          repo = "agentic.nvim";
          rev = "e84e505837afc36358b950e4941ed8fc59bfdbe4";
          hash = "sha256-q9DBNJ8L9T0y6PeR9NyL45ZRI1Sl8UvlWzANswKNPl4=";
        };
        doCheck = false;
      })
      (pkgs.vimPlugins.img-clip-nvim)
    ];

    extraConfigLua = ''
      require("img-clip").setup({})

      require("agentic").setup({
        provider = "claude-acp",
      })
    '';

    keymaps = [
      {
        key = "<leader>at";
        mode = [
          "n"
          "v"
          "i"
        ];
        action.__raw = "function() require('agentic').toggle() end";
        options = {
          desc = "Toggle Agentic Chat";
        };
      }
      {
        key = "<leader>aa";
        mode = [
          "n"
          "v"
        ];
        action.__raw = "function() require('agentic').add_selection_or_file_to_context() end";
        options = {
          desc = "Add file or selection to Agentic Context";
        };
      }
      {
        key = "<leader>an";
        mode = [
          "n"
          "v"
          "i"
        ];
        action.__raw = "function() require('agentic').new_session() end";
        options = {
          desc = "New Agentic Session";
        };
      }
      {
        key = "<leader>ac";
        mode = [
          "n"
          "v"
          "i"
        ];
        action.__raw = "function() require('agentic').close() end";
        options = {
          desc = "Close Agentic Chat";
        };
      }
      {
        key = "<leader>ao";
        mode = [
          "n"
          "v"
          "i"
        ];
        action.__raw = "function() require('agentic').open() end";
        options = {
          desc = "Open Agentic Chat";
        };
      }
      {
        key = "<leader>af";
        mode = [
          "n"
        ];
        action.__raw = "function() require('agentic').add_file() end";
        options = {
          desc = "Add current file to Agentic Context";
        };
      }
      {
        key = "<leader>as";
        mode = [
          "v"
        ];
        action.__raw = "function() require('agentic').add_selection() end";
        options = {
          desc = "Add selection to Agentic Context";
        };
      }
      {
        key = "<leader>aS";
        mode = [
          "n"
          "v"
          "i"
        ];
        action.__raw = "function() require('agentic').stop_generation() end";
        options = {
          desc = "Stop Agentic generation";
        };
      }
    ];
  };
}
