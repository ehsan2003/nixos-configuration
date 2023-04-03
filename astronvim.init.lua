return {
	-- Configure AstroNvim updates
	updater = {
		remote = "origin", -- remote to use
		channel = "stable", -- "stable" or "nightly"
		version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
		branch = "nightly", -- branch name (NIGHTLY ONLY)
		commit = nil, -- commit hash (NIGHTLY ONLY)
		pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
		skip_prompts = false, -- skip prompts about breaking changes
		show_changelog = true, -- show the changelog after performing an update
		auto_quit = false, -- automatically quit the current session after a successful update
		remotes = { -- easily add new remotes to track
			--   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
			--   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
			--   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
		},
	},

	options = {
		opt = {
			relativenumber = false, -- sets vim.opt.relativenumber
		},
	},
	-- Set colorscheme to use
	colorscheme = "nightfox",

	-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
	diagnostics = {
		virtual_text = true,
		underline = true,
	},

	lsp = {
		setup_handlers = {
			-- add custom handler
			denols = function(_, opts)
				require("deno-nvim").setup({ server = opts })
			end,
			tsserver = function(_, opts)
				require("typescript").setup({ server = opts })
			end,
		},
		-- customize lsp formatting options
		formatting = {
			-- control auto formatting on save
			format_on_save = {
				enabled = true, -- enable or disable format on save globally
				allow_filetypes = { -- enable format on save for specified filetypes only
					-- "go",
				},
				ignore_filetypes = { -- disable format on save for specified filetypes
					-- "python",
				},
			},
			disabled = { -- disable formatting capabilities for the listed language servers
				-- "sumneko_lua",
			},
			timeout_ms = 1000, -- default format timeout
			-- filter = function(client) -- fully override the default formatting function
			--   return true
			-- end
		},
		config = {
			denols = function(opts)
				opts.root_dir = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
				return opts
			end,
			["tsserver"] = function(opts)
				opts.single_file_support = false
				opts.root_dir = require("lspconfig").util.root_pattern("package.json")
				return opts
			end,
			-- For eslint:
			-- eslint = function(opts)
			--   opts.root_dir = require("lspconfig.util").root_pattern("package.json", ".eslintrc.json", ".eslintrc.js"),
			--   return opts
			-- end,
		},
		-- enable servers that you already have installed without mason
		servers = {
			-- "rust-analyzer"
			-- "pyright"
		},
	},
	plugins = {
		"sigmasd/deno-nvim", -- add lsp plugin
		{
			"williamboman/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "denols", "tsserver" }, -- automatically install lsp
			},
		},
		"jose-elias-alvarez/typescript.nvim",
		{ "EdenEast/nightfox.nvim" },
		{
			"Pocco81/auto-save.nvim",
			config = function()
				require("auto-save").setup({
					enabled = true,
					-- your config goes here
					-- or just leave it empty :)
				})
			end,
			lazy = false,
		},
	},
	mappings = {
		n = {
			L = {
				function()
					require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
				end,
				desc = "Next buffer",
			},
			H = {
				function()
					require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
				end,
				desc = "Previous buffer",
			},
		},
	},
	-- Configure require("lazy").setup() options
	lazy = {
		defaults = { lazy = true },
		performance = {
			rtp = {
				-- customize default disabled vim plugins
				disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
			},
		},
	},

	-- This function is run last and is a good place to configuring
	-- augroups/autocommands and custom filetypes also this just pure lua so
	-- anything that doesn't fit in the normal config locations above can go here
	polish = function()
		-- Set up custom filetypes
		-- vim.filetype.add {
		--   extension = {
		--     foo = "fooscript",
		--   },
		--   filename = {
		--     ["Foofile"] = "fooscript",
		--   },
		--   pattern = {
		--     ["~/%.config/foo/.*"] = "fooscript",
		--   },
		-- }
	end,
}
