vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	"https://github.com/craftzdog/solarized-osaka.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/b0o/incline.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/rachartier/tiny-cmdline.nvim",
	"https://github.com/stevearc/oil.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/b0o/SchemaStore.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	{ src = "https://github.com/craftzdog/mini.diff", version = "feat/grouping" },
	"https://github.com/esmuellert/codediff.nvim",
	"https://github.com/linrongbin16/gitlinker.nvim",
	"https://github.com/zbirenbaum/copilot.lua",
	"https://github.com/vim-denops/denops.vim",
	"https://github.com/vim-skk/skkeleton",
	"https://github.com/delphinus/skkeleton_indicator.nvim",
})

require("user.plugins.ui")
require("user.plugins.navigation")
require("user.plugins.syntax")
require("user.plugins.lsp")
require("user.plugins.completion")
require("user.plugins.formatting")
require("user.plugins.git")
require("user.plugins.ai")
require("user.plugins.japanese")

require("user.plugins.keymaps")
