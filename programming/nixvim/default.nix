{ pkgs, fenix, ... }:
{
  config = {
    plugins.bufferline.enable = true;
    plugins.markdown-preview.enable = true;

    clipboard.providers.xclip.enable = true;
    clipboard.register = "unnamedplus";
    plugins.which-key.enable = true;
    colorschemes.tokyonight.enable = true;
    globals.mapleader = " ";
    plugins.neo-tree.enable = true;
    options.shiftwidth = 2; # Tab width should be 2
    options.expandtab = true; # Tab width should be 2
    options.tabstop = 2; # Tab width should be 2
    options.softtabstop = 2; # Tab width should be 2
    options.number = true; # Tab width should be 2
    options.cmdheight = 0;
    options.signcolumn = "yes:1";
    options.cursorline = true;


    plugins.nvim-autopairs.enable = true;
    plugins.auto-save.enable = true;
    plugins.comment-nvim.enable = true;
    plugins.comment-nvim.toggler.line = "<leader>/";
    extraPlugins = with pkgs.vimPlugins ; [ smart-splits-nvim friendly-snippets ];
    plugins.toggleterm.enable = true;
    plugins.luasnip.enable = true;
    plugins.luasnip.fromVscode = [
      { }
    ];

    plugins.cmp_luasnip.enable = true;
    plugins.auto-session.enable = true;
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

    plugins.lspkind.enable = true;
    plugins.lspkind.mode = "symbol";
    plugins.nvim-cmp = {
      enable = true;
      sources = [
        { name = "nvim_lsp"; priority = 1000; }
        { name = "luasnip"; priority = 750; }
        {
          name = "buffer";
          priority = 500;
          option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
        }
        { name = "path"; priority = 250; }
      ];

      window = {
        completion = {
          border = "rounded";
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None";
          scrolloff = 0;
          colOffset = 0;
          sidePadding = 1;
          scrollbar = true;
        };
        documentation = {
          maxHeight = "math.floor(40 * (40 / vim.o.lines))";
          maxWidth = "math.floor((40 * 2) * (vim.o.columns / (40 * 2 * 16 / 9)))";
          border = "rounded";
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None";
        };
      };

      snippet.expand = "luasnip";
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = false })";
        "<C-u>" = ''cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" })'';
        "<C-d>" = ''cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" })'';
        "<C-Space>" = ''cmp.mapping.complete()'';
        "<S-Tab>" = {
          modes = [ "i" "s" ];
          action = ''
            function(fallback)
              local luasnip=require("luasnip")
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end 
          '';
        };
        "<Tab>" = {
          modes = [ "i" "s" ];
          action = ''
            function(fallback)
              local luasnip=require("luasnip")
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expandable() then
                luasnip.expand()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end
          '';
        };
      };
    };
    plugins.cmp-nvim-lsp.enable = true;
    plugins.lsp-lines.enable = true;
    plugins.gitsigns.enable = true;


    plugins.treesitter = {
      enable = true;
      incrementalSelection.enable = true;
      incrementalSelection.keymaps.initSelection = "<A-h>";
      incrementalSelection.keymaps.nodeDecremental = "<A-l>";
      incrementalSelection.keymaps.nodeIncremental = "<A-h>";
    };
    plugins.lsp = {
      enable = true;
      servers.tsserver.enable = true;

      servers.rust-analyzer = {
        enable = true;
        cargoPackage = fenix.stable.cargo;
        rustcPackage = fenix.stable.rustc;
        installCargo = false;
        installRustc = false;
      };
      servers.html.enable = true;
      servers.tailwindcss.enable = true;
      servers.svelte.enable = true;
      servers.emmet_ls.enable = true;
      servers.pyright.enable = true;
      servers.ccls.enable = true;
      servers.rnix-lsp.enable = true;
    };


    keymaps = [
      {
        key = "<leader>/";
        action = ''<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>'';
        mode = "v";
      }
      {
        key = "<leader>/";
        action = ''function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end'';
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
        key = "K";
        action = "function () vim.lsp.buf.hover() end";
        options.desc = "Hover symbol details";
        lua = true;
        mode = "n";
      }
      {
        key = "<leader>lr";
        action = "function () vim.lsp.buf.rename() end";
        options.desc = "Rename using lsp";
        lua = true;
        mode = "n";
      }
      {
        key = "<leader>lf";
        action = "function () vim.lsp.buf.format() end";
        options.desc = "Format using lsp";
        lua = true;
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
      }
      {
        key = "<leader>q";
        action = "<Cmd>confirm q<Cr>";
        options.desc = "Quit";
      }
      {
        key = "<leader>c";
        action = "<Cmd>bdelete<Cr>";
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
