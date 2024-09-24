{ pkgs, fenix, ... }: {
  plugins.markdown-preview.enable = true;
  plugins.ts-autotag.enable = true;
  plugins.typst-vim.enable = true;
  plugins.typst-vim.settings.pdf_viewer = "${pkgs.evince}/bin/evince";
  plugins.nvim-autopairs.enable = true;
  plugins = {
    none-ls = {
      enable = true;
      sources.formatting.prettier.enable = true;
      sources.formatting.prettier.disableTsServerFormatter = true;
      # sources.formatting.rustfmt.enable = true;
      sources.formatting.black.enable = true;
      sources.formatting.nixfmt.enable = true;
      # sources.formatting.beautysh.enable = true;
      sources.formatting.typstfmt.enable = true;

    };
    luasnip.enable = true;
    luasnip.fromVscode = [ { } ];
    friendly-snippets.enable = true;

    cmp_luasnip.enable = true;

    lspkind.enable = true;
    lspkind.mode = "symbol";
    cmp = {
      enable = true;
      settings = {
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = false })";
          "<C-u>" = ''cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" })'';
          "<C-d>" = ''cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" })'';
          "<C-Space>" = "cmp.mapping.complete()";
          "<S-Tab>" = ''
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
          "<Tab>" = ''
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
        snippet.expand =
          "function(args) require('luasnip').lsp_expand(args.body) end";
        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "buffer";
            priority = 500;
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
          {
            name = "path";
            priority = 250;
          }
        ];
        window = {
          completion = {
            border = "rounded";
            winhighlight =
              "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None";
            scrolloff = 0;
            colOffset = 0;
            sidePadding = 1;
            scrollbar = true;
          };
          documentation = {
            maxHeight = "math.floor(40 * (40 / vim.o.lines))";
            maxWidth =
              "math.floor((40 * 2) * (vim.o.columns / (40 * 2 * 16 / 9)))";
            border = "rounded";
            winhighlight =
              "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None";
          };
        };
      };

    };
    cmp-nvim-lsp.enable = true;

    lsp = {
      enable = true;
      servers.eslint.enable = true;
      servers.hls.enable = true;
      servers.typst-lsp.enable = true;
      servers.graphql.enable = true;
      servers.dockerls.enable = true;
      servers.docker-compose-language-service.enable = true;
      servers.denols = {
        enable = true;
        rootDir =
          ''require('lspconfig').util.root_pattern("deno.json", "deno.jsonc")'';
      };
      servers.cssls.enable = true;
      servers.prismals.enable = true;
      servers.bashls.enable = true;
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
      servers.emmet-ls.enable = true;
      servers.pyright.enable = true;
      servers.ccls.enable = true;
      servers.nixd.enable = true;
      servers.tsserver = {
        enable = true;
        extraOptions = { single_file_support = false; };
        rootDir = ''require('lspconfig').util.root_pattern("package.json")'';
      };
    };
  };
  keymaps = [
    {
      key = "<leader>la";
      action.__raw = "function() vim.lsp.buf.code_action() end";
      options.desc = "Code action";
      mode = "v";
    }
    {
      key = "<leader>la";
      action.__raw = "function() vim.lsp.buf.code_action() end";
      options.desc = "Code action";
      mode = "n";
    }
    {
      key = "gd";
      action.__raw =
        ''function() require("telescope.builtin").lsp_definitions() end'';
      options.desc = "Go to definition";
      mode = "n";
    }
    {
      key = "gr";
      action.__raw =
        ''function() require("telescope.builtin").lsp_references() end'';
      options.desc = "References of current symbol";
      mode = "n";
    }
    {
      key = "<leader>lR";
      action.__raw =
        ''function() require("telescope.builtin").lsp_references() end'';
      options.desc = "Search references";
      mode = "n";
    }
    {
      key = "<leader>lr";
      action.__raw = "function() vim.lsp.buf.rename() end";
      options.desc = "Rename current symbol";
      mode = "n";
    }
    {
      key = "<leader>lh";
      action.__raw = "function() vim.lsp.buf.signature_help() end";
      options.desc = "Signature help";
      mode = "n";
    }
    {
      key = "gy";
      action.__raw =
        ''function() require("telescope.builtin").lsp_type_definitions() end'';
      options.desc = "Definition of current type";
      mode = "n";
    }
    {
      key = "<leader>lG";
      action.__raw = ''
        function()
          vim.ui.input({ prompt = "Symbol Query:" }, function(query)
            if query then
              -- word under cursor if given query is empty
              if query == "" then query = vim.fn.expand "<cword>" end
              require("telescope.builtin").lsp_workspace_symbols {
                query = query,
                prompt_title = ("Find word (%s)"):format(query),
              }
            end
          end)
        end
      '';
      options.desc = "Search workspace symbols";
      mode = "n";
    }
    {
      key = "K";
      action.__raw = "function () vim.lsp.buf.hover() end";
      options.desc = "Hover symbol details";
      mode = "n";
    }
    {
      key = "<leader>lr";
      action.__raw = "function () vim.lsp.buf.rename() end";
      options.desc = "Rename using lsp";
      mode = "n";
    }
    {
      key = "<leader>ld";
      action.__raw = "function() vim.diagnostic.open_float() end";
      options.desc = "Hover diagnostics";
      mode = "n";
    }
    {
      key = "[d";
      action.__raw = "function() vim.diagnostic.goto_prev() end";
      options.desc = "Previous diagnostic";
      mode = "n";
    }
    {
      key = "]d";
      action.__raw = "function() vim.diagnostic.goto_next() end";
      options.desc = "Next diagnostic";
      mode = "n";
    }
    {
      key = "gl";
      action.__raw = "function() vim.diagnostic.open_float() end";
      options.desc = "Hover diagnostics";
      mode = "n";
    }
    {
      key = "<leader>lf";
      action.__raw = "function () vim.lsp.buf.format() end";
      options.desc = "Format using lsp";
      mode = "n";
    }
  ];
  extraConfigLua = ''
    local cmp=require('cmp')
    cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done { tex = false })
  '';
}
