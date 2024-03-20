return {
	-- Create annotations with one keybind, and jump your cursor in the inserted annotation
	{
		"danymat/neogen",
		keys = {
			{
				"<leader>cc",
				function()
					require("neogen").generate({})
				end,
				desc = "Neogen Comment",
			},
		},
		opts = { snippet_engine = "luasnip" },
	},

	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},

	-- Refactoring tool
	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<leader>r",
				function()
					require("refactoring").select_refactor()
				end,
				mode = "v",
				noremap = true,
				silent = true,
				expr = false,
			},
		},
		opts = {},
	},

	-- Go forward/backward with square brackets
	{
		"echasnovski/mini.bracketed",
		event = "BufReadPost",
		config = function()
			local bracketed = require("mini.bracketed")
			bracketed.setup({
				file = { suffix = "" },
				window = { suffix = "" },
				quickfix = { suffix = "" },
				yank = { suffix = "" },
				treesitter = { suffix = "n" },
			})
		end,
	},

	-- Better increase/descrease
	{
		"monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool,
					augend.semver.alias.semver,
					augend.constant.new({ elements = { "let", "const" } }),
				},
			})
		end,
	},

	{
		"simrat39/symbols-outline.nvim",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		cmd = "SymbolsOutline",
		opts = {
			position = "right",
		},
	},

	{
		"nvim-cmp",
		dependencies = { "hrsh7th/cmp-emoji", "rinx/cmp-skkeleton" },
		opts = function(_, opts)
			local cmp = require("cmp")
			table.insert(opts.sources, { name = "emoji" })
			table.insert(opts.sources, {
				name = "skkeleton",
				option = {
					filter_func = function(input)
						return not string.find(input, "[a-zA-Z0-9]")
					end,
				},
			})
			opts.sources = cmp.config.sources(opts.sources, {
				{ name = "skkeleton", priority_weight = 20 },
			})
		end,
	},

	{
		"vim-denops/denops.vim",
		dependencies = {
			{
				"vim-skk/skkeleton",
				config = function()
					vim.fn["skkeleton#config"]({
						globalDictionaries = {
							"~/Library/Application Support/AquaSKK/SKK-JISYO.L",
						},
					})
				end,
			},
			{
				"delphinus/skkeleton_indicator.nvim",
				config = function()
					require("skkeleton_indicator").setup()
				end,
			},
		},
	},
}
