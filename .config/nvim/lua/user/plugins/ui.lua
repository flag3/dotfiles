require("solarized-osaka").setup({
	style = "vivid",
	transparent = true,
})
vim.cmd.colorscheme("solarized-osaka")

require("tiny-cmdline").setup({
	position = { y = "20%" },
})

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

User.tabline.setup()

local ROOT_MARKERS = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

local function root_dir()
	return vim.fs.root(0, ROOT_MARKERS) or vim.fn.getcwd()
end

local function root_name()
	local root = root_dir()
	if root == vim.fn.getcwd() then
		return ""
	end
	return vim.fs.basename(root)
end

local function pretty_path()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		return ""
	end
	return vim.fs.relpath(root_dir(), path) or vim.fn.fnamemodify(path, ":~")
end

local function recording()
	local reg = vim.fn.reg_recording()
	return reg == "" and "" or "recording @" .. reg
end

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		refresh = {
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
				"RecordingEnter",
				"RecordingLeave",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			root_name,
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			pretty_path,
		},
		lualine_x = { recording, "diagnostics", "diff" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

require("incline").setup({
	hide = { cursorline = true },
	render = function(props)
		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if name == "" then
			name = "[No Name]"
		end
		local icon, icon_hl = MiniIcons.get("file", name)
		return {
			{ icon, " ", group = icon_hl },
			name,
			vim.bo[props.buf].modified and " [+]" or "",
		}
	end,
})

require("snacks").setup({
	picker = { enabled = true },
	lazygit = {
		theme = { activeBorderColor = { fg = "WarningMsg", bold = true } },
	},
	notifier = { enabled = true },
	indent = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	scroll = { enabled = false },
})
