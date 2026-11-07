require("gitsigns").setup()

require("mini.diff").setup({
	view = { overlay_style = "hunk" },
})

require("codediff").setup({
	diff = {
		compact = true,
		compact_context_lines = 8,
		compact_sync_folds = true,
	},
	explorer = {
		view_mode = "tree",
		width = 50,
		auto_open_on_cursor = true,
		line_stats = { enabled = true },
	},
})

require("gitlinker").setup()
