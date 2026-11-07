local M = {}

local PAD = "   "
local MAX_NAME = 20
local CUT_NAME = 17
local SEP_LEFT = "\u{e0ba}" -- ◢
local SEP_RIGHT = "\u{e0b8}" -- ◣

local function label(buf)
	if vim.bo[buf].buftype == "terminal" then
		return "[Terminal]"
	end
	if vim.bo[buf].filetype == "oil" then
		local dir = vim.fn.fnamemodify(require("oil").get_current_dir(buf) or "", ":~"):gsub("/$", "")
		local len = vim.fn.strchars(dir)
		if len > MAX_NAME then
			dir = "…" .. vim.fn.strcharpart(dir, len - CUT_NAME)
		end
		return dir
	end
	local path = vim.api.nvim_buf_get_name(buf)
	if path == "" then
		return "[No Name]"
	end
	local name = vim.fn.fnamemodify(path, ":t")
	local icon = MiniIcons.get("file", name)
	if vim.fn.strchars(name) > MAX_NAME then
		name = vim.fn.strcharpart(name, 0, CUT_NAME) .. "…"
	end
	return icon .. " " .. name
end

local function tab(nr, is_active)
	local win = vim.api.nvim_tabpage_get_win(nr)
	local buf = vim.api.nvim_win_get_buf(win)
	local text = label(buf):gsub("%%", "%%%%")
	if vim.bo[buf].modified then
		text = "[+] " .. text
	end
	local hl = is_active and "UserTabActive" or "UserTabInactive"
	return ("%%%dT%%#%sSep#%s%%#%s#%s%s%s%%#%sSep#%s"):format(
		vim.api.nvim_tabpage_get_number(nr),
		hl,
		SEP_LEFT,
		hl,
		PAD,
		text,
		PAD,
		hl,
		SEP_RIGHT
	)
end

function M.render()
	local current = vim.api.nvim_get_current_tabpage()
	local parts = {}
	for _, nr in ipairs(vim.api.nvim_list_tabpages()) do
		parts[#parts + 1] = tab(nr, nr == current)
	end
	return table.concat(parts) .. "%#TabLineFill#%T"
end

function M.setup()
	local c = require("solarized-osaka.colors").setup()
	local set = vim.api.nvim_set_hl
	set(0, "UserTabActive", { fg = c.base4, bg = c.yellow, bold = true })
	set(0, "UserTabActiveSep", { fg = c.yellow })
	set(0, "UserTabInactive", { fg = c.base0, bg = c.base02 })
	set(0, "UserTabInactiveSep", { fg = c.base02 })
	set(0, "TabLineFill", {})

	vim.o.showtabline = 1
	vim.o.tabline = "%!v:lua.User.tabline.render()"
end

return M
