-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

keymap.set("i", "<C-j>", "<Plug>(skkeleton-enable)", {
	noremap = true,
	silent = true,
	desc = "Evaluate",
})

-- Pandoc
local function is_pandoc_compatible()
	return vim.tbl_contains({ "markdown", "md", "tex", "latex", "org", "rst", "html", "docx" }, vim.bo.filetype)
end

if is_pandoc_compatible() then
	keymap.set("n", "<leader>p", "", { desc = "pandoc" })

	keymap.set("n", "<leader>ph", function()
		vim.cmd("!pandoc %:p -o %:p:r.html")
	end, { desc = "html" })

	keymap.set("n", "<leader>pl", function()
		vim.cmd("!pandoc %:p -o %:p:r.tex")
	end, { desc = "latex" })

	keymap.set("n", "<leader>pm", function()
		vim.cmd("!pandoc %:p -o %:p:r.md")
	end, { desc = "markdown" })

	keymap.set("n", "<leader>pp", function()
		vim.cmd(
			"!pandoc %:p -o %:p:r.pdf --pdf-engine=lualatex -V documentclass=ltjsarticle -V luatexjapresetoptions=hiragino-pron"
		)
	end, { desc = "pdf" })

	keymap.set("n", "<leader>pt", function()
		vim.cmd("!pandoc %:p -o %:p:r.typ")
	end, { desc = "typst" })

	keymap.set("n", "<leader>pv", function()
		vim.cmd("!open -a Skim %:p:r.pdf &")
	end, { desc = "view" })

	keymap.set("n", "<leader>pw", function()
		vim.cmd("!pandoc %:p -o %:p:r.docx")
	end, { desc = "word" })
end
