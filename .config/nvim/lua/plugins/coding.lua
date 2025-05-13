return {
	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
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

	-- copilot
	{
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<C-l>",
					accept_word = "<M-l>",
					accept_line = "<M-S-l>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},

	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			-- add any opts here
			-- for example
			provider = "claude",
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-3-7-sonnet-20250219", -- your desired model (or use gpt-4o, etc.)
				timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
				temperature = 0,
				max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
				--reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
			},
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},

	{
		"vim-denops/denops.vim",
		dependencies = {
			{
				"vim-skk/skkeleton",
				config = function()
					vim.fn["skkeleton#config"]({
						globalDictionaries = {
							"~/Library/Application Support/AquaSKK/skk-jisyo.utf8",
							"~/Library/Application Support/AquaSKK/SKK-JISYO.L",
							"~/dotfiles/SKK-JISYO.latex.utf8",
						},
						showCandidatesCount = 1,
					})
					vim.api.nvim_create_autocmd("FileType", {
						pattern = "tex",
						callback = function()
							vim.fn["skkeleton#register_kanatable"]("rom", {
								[","] = { "，", "" },
								["."] = { "．", "" },
							})
						end,
					})
				end,
			},
			{
				"delphinus/skkeleton_indicator.nvim",
				config = function()
					vim.api.nvim_set_hl(0, "SkkeletonIndicatorEiji", { fg = "#ffffff", bg = "#9b9b9b", bold = true })
					vim.api.nvim_set_hl(0, "SkkeletonIndicatorHira", { fg = "#ffffff", bg = "#ff7d00", bold = true })
					vim.api.nvim_set_hl(0, "SkkeletonIndicatorKata", { fg = "#ffffff", bg = "#78a741", bold = true })
					vim.api.nvim_set_hl(0, "SkkeletonIndicatorHankata", { fg = "#ffffff", bg = "#ab7fd5", bold = true })
					vim.api.nvim_set_hl(0, "SkkeletonIndicatorZenkaku", { fg = "#ffffff", bg = "#ffd401", bold = true })
					vim.api.nvim_set_hl(0, "SkkeletonIndicatorAbbrev", { fg = "#ffffff", bg = "#9b9b9b", bold = true })
					require("skkeleton_indicator").setup({
						eijiText = " ＠ ",
						hiraText = " あ ",
						kataText = " ア ",
						hankataText = " ｶﾅ ",
						zenkakuText = " 英 ",
						abbrevText = " ＠ ",
					})
				end,
			},
		},
	},
}
