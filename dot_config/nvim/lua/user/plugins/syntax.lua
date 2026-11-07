require("nvim-treesitter").install({
	"astro",
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"diff",
	"fish",
	"gitignore",
	"go",
	"graphql",
	"html",
	"http",
	"java",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"php",
	"printf",
	"python",
	"query",
	"regex",
	"rust",
	"scss",
	"sql",
	"svelte",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
	-- 9.2
	"python",
	"vue",
	"latex",
	"typst",
	"terraform",
	"hcl",
	"dockerfile",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if not lang or not vim.treesitter.language.add(lang) then
			return
		end
		vim.treesitter.start(args.buf, lang)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

require("todo-comments").setup()

require("nvim-highlight-colors").setup({
	render = "background",
	enable_tailwind = false,
})
vim.lsp.document_color.enable(false)

vim.filetype.add({ extension = { mdx = "mdx" } })
vim.treesitter.language.register("markdown", "mdx")
