local map = vim.keymap.set

map("n", "x", '"_x', { desc = "Delete char without copying" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without copying" })
map({ "n", "x" }, "<leader>c", '"_c', { desc = "Change without copying" })
map("n", "<leader>p", '"0p', { desc = "Paste last yank" })
map("x", "<leader>p", '"_dP', { desc = "Paste without copying" })
map("n", "dw", 'vb"_d', { desc = "Delete word backwards without copying" })

map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

map("n", "te", "<Cmd>tabedit<CR>", { desc = "New tab" })
map("n", "<Tab>", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<S-Tab>", "<Cmd>tabprev<CR>", { desc = "Previous tab" })

map("n", "ss", "<Cmd>split<CR>", { desc = "Split below" })
map("n", "sv", "<Cmd>vsplit<CR>", { desc = "Split right" })
map("n", "sh", "<C-w>h", { desc = "Window left" })
map("n", "sj", "<C-w>j", { desc = "Window down" })
map("n", "sk", "<C-w>k", { desc = "Window up" })
map("n", "sl", "<C-w>l", { desc = "Window right" })

map("n", "<C-m>", "<C-i>", { desc = "Jump forward" })

map("n", "<leader>o", "o<Esc>^Da", { desc = "Open line below without comment" })
map("n", "<leader>O", "O<Esc>^Da", { desc = "Open line above without comment" })

map("n", "<leader>bd", function()
	for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if #buf.windows == 0 and buf.changed == 0 then
			vim.api.nvim_buf_delete(buf.bufnr, {})
		end
	end
end, { desc = "Close hidden buffers" })

local function copy_path(modifier)
	local text = vim.fn.expand("%" .. modifier) .. "#L" .. vim.fn.line(".")
	vim.fn.setreg("+", text)
	vim.notify("Copied " .. text)
end

map("n", "<leader>yf", function()
	copy_path(":.")
end, { desc = "Copy relative path with line" })
map("n", "<leader>yp", function()
	copy_path(":p")
end, { desc = "Copy absolute path with line" })

local SHORT_LANG = {
	typescriptreact = "tsx",
	javascriptreact = "jsx",
	typescript = "ts",
	javascript = "js",
}

map("x", "<leader>cc", function()
	local from, to = vim.fn.getpos("v"), vim.fn.getpos(".")
	local lines = vim.fn.getregion(from, to, { type = vim.fn.mode() })
	local ft = vim.bo.filetype
	local header = ('```%s filename="%s" line=%d'):format(
		SHORT_LANG[ft] or ft,
		vim.fn.expand("%:."),
		math.min(from[2], to[2])
	)
	vim.fn.setreg("+", header .. "\n" .. table.concat(lines, "\n") .. "\n```\n")
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
end, { desc = "Copy selection as Markdown code block" })
