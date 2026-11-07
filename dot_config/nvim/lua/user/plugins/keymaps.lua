local map = vim.keymap.set

map("n", "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
map("n", "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous reference" })

map("n", ";f", function()
	Snacks.picker.files({ hidden = true })
end, { desc = "Find files" })
map("n", ";r", function()
	Snacks.picker.grep({ hidden = true })
end, { desc = "Live grep" })
map("n", ";;", function()
	Snacks.picker.resume()
end, { desc = "Resume last picker" })
map("n", "\\\\", function()
	Snacks.picker.buffers({ jump = { reuse_win = true } })
end, { desc = "Buffers" })
map("n", ";e", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", ";n", function()
	Snacks.picker.notifications()
end, { desc = "Notification history" })
map("n", ";h", function()
	Snacks.picker.git_diff()
end, { desc = "Git hunks" })

map("n", "sf", function()
	require("oil").open_float(nil, { preview = {} })
end, { desc = "File explorer" })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function(args)
		map("n", "h", require("oil").open, { buffer = args.buf, desc = "Parent directory" })
		map("n", "q", require("oil").close, { buffer = args.buf, desc = "Close oil" })
	end,
})

local function source_definition(client)
	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:exec_cmd({
		title = "Go to source definition",
		command = "typescript.goToSourceDefinition",
		arguments = { params.textDocument.uri, params.position },
	}, { bufnr = 0 }, function(err, result)
		if err or not result or vim.tbl_isempty(result) then
			vim.notify("No source definition found", vim.log.levels.WARN)
			return
		end
		vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
	end)
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local function lmap(mode, lhs, rhs, desc)
			map(mode, lhs, rhs, { buffer = args.buf, desc = desc, nowait = true })
		end

		lmap("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, "Go to definition")
		lmap("n", "gD", function()
			Snacks.picker.lsp_declarations()
		end, "Go to declaration")
		lmap("n", "gy", function()
			Snacks.picker.lsp_type_definitions()
		end, "Go to type definition")
		lmap("n", "gr", function()
			Snacks.picker.lsp_references()
		end, "References")
		lmap("n", "gI", function()
			local vtsls = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })[1]
			if vtsls then
				source_definition(vtsls)
			else
				Snacks.picker.lsp_implementations()
			end
		end, "Go to source definition / implementation")
		lmap("n", ";c", function()
			Snacks.picker.lsp_incoming_calls()
		end, "Incoming calls")
		lmap("n", "K", vim.lsp.buf.hover, "Hover")
		lmap("n", "gK", vim.lsp.buf.signature_help, "Signature help")
		lmap("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
		lmap({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
		lmap("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
		lmap("n", "<leader>cl", "<Cmd>checkhealth vim.lsp<CR>", "LSP info")
	end,
})

map("n", "<C-j>", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "<leader>cR", function()
	Snacks.rename.rename_file()
end, { desc = "Rename file" })
map({ "n", "x" }, "<leader>f", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format" })

local function open_line_commit()
	local file = vim.api.nvim_buf_get_name(0)
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local result = vim.system(
		{ "git", "blame", "--porcelain", "-L", line .. "," .. line, "--", vim.fs.basename(file) },
		{ cwd = vim.fs.dirname(file), text = true }
	):wait()
	local sha = result.code == 0 and result.stdout:match("^(%x+)")
	if not sha or sha:match("^0+$") then
		vim.notify("No commit for this line", vim.log.levels.WARN)
		return
	end
	vim.cmd("tab split")
	require("gitsigns").show(sha)
end

map("n", "<leader>gb", function()
	require("gitsigns").blame_line()
end, { desc = "Blame line" })
map("n", "<leader>gB", function()
	require("gitsigns").blame()
end, { desc = "Blame buffer" })
map("n", "<leader>go", open_line_commit, { desc = "Open file at line's commit" })
map("n", "<leader>gs", function()
	local gs = require("gitsigns")
	if vim.tbl_isempty(gs.get_hunks() or {}) then
		gs.reset_buffer_index()
	else
		gs.stage_buffer()
	end
end, { desc = "Stage / unstage buffer" })
map("n", "<leader>gh", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage / unstage hunk" })

map("n", "<leader>gd", function()
	MiniDiff.toggle_overlay()
end, { desc = "Toggle diff overlay" })
map("n", "]c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		MiniDiff.goto_hunk("next")
	end
end, { desc = "Next hunk" })
map("n", "[c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		MiniDiff.goto_hunk("prev")
	end
end, { desc = "Previous hunk" })

map("n", "<leader>dv", function()
	-- ponytail: codediff has no public toggle; lifecycle.close() is internal and returns false when this tab has no session
	if not require("codediff.ui.lifecycle").close() then
		vim.cmd("CodeDiff")
	end
end, { desc = "Toggle diff view" })
map("n", "<leader>dh", "<Cmd>CodeDiff history %<CR>", { desc = "File history" })
map("n", "<leader>dH", "<Cmd>CodeDiff history<CR>", { desc = "Repo history" })

map("n", ";g", User.lazygit.open, { desc = "Lazygit" })

map("n", "<leader>j", function()
	local root = vim.fs.root(0, "package.json")
	if not root then
		vim.notify("No package.json found", vim.log.levels.WARN)
		return
	end
	Snacks.win({
		file = vim.fs.joinpath(root, "package.json"),
		width = 0.8,
		height = 0.8,
		border = "rounded",
		keys = { q = "close", ["<Esc>"] = "close" },
	})
end, { desc = "Open package.json" })

local function copilot(action)
	return function()
		require("copilot.suggestion")[action]()
	end
end

map("i", "<C-l>", copilot("accept"), { desc = "Copilot accept" })
map("i", "<M-l>", copilot("accept_word"), { desc = "Copilot accept word" })
map("i", "<M-L>", copilot("accept_line"), { desc = "Copilot accept line" })
map("i", "<M-]>", copilot("next"), { desc = "Copilot next suggestion" })
map("i", "<M-[>", copilot("prev"), { desc = "Copilot previous suggestion" })
map("i", "<C-]>", copilot("dismiss"), { desc = "Copilot dismiss" })

map("i", "<C-j>", "<Plug>(skkeleton-enable)", { desc = "Enable skkeleton" })
