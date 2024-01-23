{ pkgs, fenix, ... }:
{
  imports = [ ./lsp.nix ];
  config = {
    plugins.bufferline.enable = true;
    plugins.markdown-preview.enable = true;

    clipboard.providers.xclip.enable = true;
    clipboard.register = "unnamedplus";
    plugins.which-key.enable = true;
    plugins.which-key.registrations = {
      "<leader>f" = "Find";
      "<leader>t" = "Terminal";
      "<leader>l" = "Lsp";
      "<leader>g" = "Git";
    };
    colorschemes.tokyonight.enable = true;
    globals.mapleader = " ";
    plugins.neo-tree.enable = true;
    plugins.neo-tree.filesystem.filteredItems.hideHidden = true;

    options.shiftwidth = 2; # Tab width should be 2
    options.expandtab = true; # Tab width should be 2
    options.tabstop = 2; # Tab width should be 2
    options.softtabstop = 2; # Tab width should be 2
    options.number = true; # Tab width should be 2
    options.cmdheight = 0;
    options.signcolumn = "yes:1";
    options.cursorline = true;

    plugins.noice.enable = true;
    plugins.noice.presets = {
      bottom_search = true;
      command_palette = true;
      long_message_to_split = true;
      inc_rename = false;
      lsp_doc_border = false;
    };
    plugins.noice.popupmenu.enabled = false;

    plugins.nvim-autopairs.enable = true;
    plugins.auto-save.enable = true;
    plugins.comment-nvim.enable = true;
    plugins.comment-nvim.toggler.line = "<leader>/";
    extraPlugins = with pkgs.vimPlugins ; [ smart-splits-nvim friendly-snippets dressing-nvim ];
    plugins.toggleterm.enable = true;
    plugins.auto-session.enable = true;
    plugins.auto-session.bypassSessionSaveFileTypes = [ "neo-tree" ];
    plugins.lualine.enable = true;
    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>fw" = {
          desc = "search";
          action = "live_grep";
        };
        "<leader>ff" = {
          desc = "file finder";
          action = "find_files";
        };
      };
    };
    plugins.gitsigns.enable = true;
    plugins.treesitter = {
      enable = true;
      incrementalSelection.enable = true;
      incrementalSelection.keymaps.initSelection = "<A-h>";
      incrementalSelection.keymaps.nodeDecremental = "<A-l>";
      incrementalSelection.keymaps.nodeIncremental = "<A-h>";
    };



    keymaps = [
      {
        key = "]g";
        action = ''<cmd>Gitsigns prev_hunk<cr>'';
        mode = "n";
      }
      {
        key = "[g";
        action = ''<cmd>Gitsigns next_hunk<cr>'';
        mode = "n";
      }
      {
        key = "<leader>gd";
        action = ''<cmd>Gitsigns diffthis<cr>'';
        mode = "n";
      }
      {
        key = "<leader>/";
        action = ''<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>'';
        options.desc = "Comment visual text";
        mode = "v";
      }
      {
        key = "<leader>/";
        action = ''function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end'';
        options.desc = "Comment line";
        lua = true;
        mode = "n";
      }

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
      {
        # Default mode is "" which means normal-visual-op
        key = "<leader>e";
        action = "<Cmd>Neotree toggle<CR>";
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
  };

}