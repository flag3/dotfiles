return {
	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},

	-- Go forward/backward with square brackets
	{
		"nvim-mini/mini.bracketed",
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
