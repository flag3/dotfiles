require("copilot").setup({
	suggestion = {
		auto_trigger = true,
		-- keys live in plugins/keymaps.lua
		keymap = {
			accept = false,
			accept_word = false,
			accept_line = false,
			next = false,
			prev = false,
			dismiss = false,
		},
	},
	filetypes = {
		markdown = true,
		help = true,
	},
})
